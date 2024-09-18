import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UITextField!
    

    
    var task: String?
    var taskIndex: Int?  // Added this to track the index of the task to be deleted
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.title = task
        descriptionLabel.backgroundColor = .darkGray
        
        // Update the title and description labels with task data
        loadTaskDetails()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(confirmDeleteTask))
    }
    
    //loading task details function
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
           
//           // Customize button appearance
//           let messageLabel = alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.first?.subviews.first as? UILabel
//           messageLabel?.textColor = .white
//
//           let buttonSubviews = alert.view.subviews.first?.subviews.first?.subviews.flatMap { $0.subviews }
//           buttonSubviews?.forEach { button in
//               if let actionButton = button as? UIButton {
//                   actionButton.setTitleColor(.black, for: .normal)
//               }
//           }
        
        present(alert, animated: true, completion: nil)
    }
    
    // Function to delete a task
//    @objc func deleteTask() {
//        guard let index = taskIndex else {
//            print("Task index is not set.")
//            return
//        }
//
//        var count = UserDefaults.standard.integer(forKey: "count")
//        
//        if index >= count || index < 0 {
//            print("Invalid task index.")
//            return
//        }
//        
//        UserDefaults.standard.removeObject(forKey: "task_\(index)")
//        
//        for i in index..<count-1 {
//            let nextTask = UserDefaults.standard.string(forKey: "task_\(i + 1)")
//            UserDefaults.standard.set(nextTask, forKey: "task_\(i)")
//        }
//        
//        UserDefaults.standard.removeObject(forKey: "task_\(count - 1)")
//        
//        count -= 1
//        UserDefaults.standard.set(count, forKey: "count")
//        
//        print("Deleted task at index \(index), new task count is \(count)")
//        
//        fetchAllTasks()
//        navigationController?.popViewController(animated: true)
//    }
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
                print("Task found for key \(taskKey):", task)
                tasks.append(task)
            } else {
                print("No task found for key \(taskKey)")
            }
        }
        
        print("ALL TASKS ---", tasks)
    }
}
