import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UITextField!
    
    var task: String?
    var taskIndex: Int?  // Track the index of the task to be edited or deleted

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.title = task
        descriptionLabel.backgroundColor = .darkGray
        
        // Update the title and description labels with task data
        loadTaskDetails()
        // Add a black border around the descriptionLabel
            descriptionLabel.layer.borderColor = UIColor.black.cgColor
            descriptionLabel.layer.borderWidth = 1.0 // Adjust the width as needed
            descriptionLabel.layer.cornerRadius = 5.0 // Optional: round the corners
            descriptionLabel.clipsToBounds = true // Ensure the corners are clipped

        
        // Create edit button
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editDescription))
        editButton.tintColor = .black
        
        // Create delete button
        let deleteButton = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(confirmDeleteTask))
        deleteButton.tintColor = .black
        
        // Add both buttons to the navigation bar
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }
    
    // Edit description function
    @objc func editDescription() {  // Method to handle description editing
        guard let index = taskIndex else {
            print("Task index is not set.")
            return
        }
        
        let currentDescription = UserDefaults.standard.string(forKey: "task_description_\(index)") ?? ""
        
        let alert = UIAlertController(title: "Edit Description", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = currentDescription
            textField.backgroundColor = .gray
            textField.textColor = .black
            textField.autocorrectionType = .no
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newDescription = alert.textFields?.first?.text else { return }
            self?.saveUpdatedDescription(newDescription) // Call to save updated description
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true) {
            // Customize the appearance of the alert
            let subview = alert.view.subviews.first?.subviews.first?.subviews.first
            subview?.backgroundColor = .yellow
            subview?.layer.cornerRadius = 10
        }
    }
    
    // Save description update and update timestamp
    func saveUpdatedDescription(_ newDescription: String) {
        guard let index = taskIndex else {
            print("Task index is not set.")
            return
        }
        
        UserDefaults.standard.set(newDescription, forKey: "task_description_\(index)")
        descriptionLabel.text = newDescription
        
        // Update the timestamp when description is saved
        let currentDate = Date() // Current date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        
        UserDefaults.standard.set(formattedDate, forKey: "task_timestamp_\(index)")
        
        print("Updated description and timestamp for task at index \(index)")
    }
    
    // Load task details function, including timestamp
    func loadTaskDetails() {
        self.view.backgroundColor = .gray

        guard let index = taskIndex else {
            print("Task index is not set.")
            return
        }
        
        // Retrieve description from the selected task
        let description = UserDefaults.standard.string(forKey: "task_description_\(index)") ?? "No description"
        descriptionLabel.text = description

        // Load and display the timestamp if available
        let timestamp = UserDefaults.standard.string(forKey: "task_timestamp_\(index)") ?? "No timestamp"
        print("Task created/updated at: \(timestamp)")
    }
    
    // Confirm before deleting
    @objc func confirmDeleteTask() {
        let alert = UIAlertController(title: "Delete Task?", message: "Are Ya Sure of That?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "YAS", style: .destructive) { [weak self] _ in
            self?.deleteTask()
        }
        
        let noAction = UIAlertAction(title: "NICHT", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        // Customize the appearance of the alert
        let subview = alert.view.subviews.first?.subviews.first?.subviews.first
        subview?.backgroundColor = .yellow
        subview?.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    // Function to delete a task
    @objc func deleteTask() {
        guard let index = taskIndex else {
            print("Task index is not set.")
            return
        }

        var count = UserDefaults.standard.integer(forKey: "count")
        
        if index >= count || index < 0 {
            print("Invalid task index.")
            return
        }
        
        // Remove the task and its description
        UserDefaults.standard.removeObject(forKey: "task_\(index)")
        UserDefaults.standard.removeObject(forKey: "task_description_\(index)")
        UserDefaults.standard.removeObject(forKey: "task_timestamp_\(index)") // Remove timestamp
        
        // Shift tasks to fill the gap
        for i in index..<count-1 {
            let nextTask = UserDefaults.standard.string(forKey: "task_\(i + 1)")
            let nextDescription = UserDefaults.standard.string(forKey: "task_description_\(i + 1)")
            let nextTimestamp = UserDefaults.standard.string(forKey: "task_timestamp_\(i + 1)")
            
            UserDefaults.standard.set(nextTask, forKey: "task_\(i)")
            UserDefaults.standard.set(nextDescription, forKey: "task_description_\(i)")
            UserDefaults.standard.set(nextTimestamp, forKey: "task_timestamp_\(i)")
        }
        
        // Remove the last task and description
        UserDefaults.standard.removeObject(forKey: "task_\(count - 1)")
        UserDefaults.standard.removeObject(forKey: "task_description_\(count - 1)")
        UserDefaults.standard.removeObject(forKey: "task_timestamp_\(count - 1)")
        
        // Update the count
        count -= 1
        UserDefaults.standard.set(count, forKey: "count")
        
        print("Deleted task at index \(index), new task count is \(count)")
        
        // Notify the view to update
        fetchAllTasks()
        navigationController?.popViewController(animated: true)
    }

    func fetchAllTasks() {
        var tasks = [String]()
        let count = UserDefaults.standard.integer(forKey: "count")
        print("COUNT ---", count)
        
        for x in 0..<count {
            let taskKey = "task_\(x)"
            if let task = UserDefaults.standard.string(forKey: taskKey) {
                let numberedTask = "\(x + 1). \(task)"
                tasks.append(numberedTask)
            }
        }

        print("ALL TASKS ---", tasks)
    }
}
