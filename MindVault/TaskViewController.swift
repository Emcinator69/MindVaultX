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
            self?.saveUpdatedDescription(newDescription)// Call to save updated description
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
    
    // Save description update
    func saveUpdatedDescription(_ newDescription: String) {
        guard let index = taskIndex else {
            print("Task index is not set.")
            return
        }
        
        UserDefaults.standard.set(newDescription, forKey: "task_description_\(index)")
        descriptionLabel.text = newDescription
        
        print("Updated description for task at index \(index)")
    }
    
    // Load task details function
    func loadTaskDetails() {
        self.view.backgroundColor = .gray

        guard let index = taskIndex else {
            print("Task index is not set.")
            return
        }
        
        // Retrieve description from the selected task
        let description = UserDefaults.standard.string(forKey: "task_description_\(index)") ?? "No description"
        descriptionLabel.text = description
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
        
        // Shift tasks to fill the gap
        for i in index..<count-1 {
            let nextTask = UserDefaults.standard.string(forKey: "task_\(i + 1)")
            let nextDescription = UserDefaults.standard.string(forKey: "task_description_\(i + 1)")
            
            UserDefaults.standard.set(nextTask, forKey: "task_\(i)")
            UserDefaults.standard.set(nextDescription, forKey: "task_description_\(i)")
        }
        
        // Remove the last task and description
        UserDefaults.standard.removeObject(forKey: "task_\(count - 1)")
        UserDefaults.standard.removeObject(forKey: "task_description_\(count - 1)")
        
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
            print("TASK KEY ---", taskKey)
            if let task = UserDefaults.standard.string(forKey: taskKey) {
                let numberedTask = "\(x + 1). \(task)"  // Numbering the task starting from 1

                print("Task found for key \(taskKey):", task)
                tasks.append(task)
                
                print("Task found for key \(taskKey):", numberedTask)
                tasks.append(numberedTask)  //Append task with number

            } else {
                print("No task found for key \(taskKey)")
            }
        }
        

        print("ALL TASKS ---", tasks)
    }
}
