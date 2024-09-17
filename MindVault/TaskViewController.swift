import UIKit

class TaskViewController: UIViewController {

    @IBOutlet var label: UILabel!
    var task: String?
    var taskIndex: Int?  // Added this to track the index of the task to be deleted
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(confirmDeleteTask))
    }
    
    //confirm before deleting
    @objc func confirmDeleteTask(){
        //create alert
        let alert = UIAlertController (title: "Delete Note", message: "Are Ya Sure of That?", preferredStyle: .alert)
        
        //confirm/yes action
        let yesAction = UIAlertAction (title: "YAS", style: .destructive) {
            [weak self] _ in self?.deleteTask() // Call deleteTask if confirmed
        }
        //no action
        let noAction = UIAlertAction (title: "NICHT", style: .cancel, handler: nil)
        
        //add actions to alert
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        //Show the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func deleteTask() {
        // Check if the task index is set
        guard let index = taskIndex else {
            print("Task index is not set.")
            return
        }

        // Retrieve the current count of tasks
        var count = UserDefaults.standard.integer(forKey: "count")
        
        // Check if the index is valid
        if index >= count || index < 0 {
            print("Invalid task index.")
            return
        }
        
        // Remove the task at the specified index
        UserDefaults.standard.removeObject(forKey: "task_\(index)")
        
        // Shift all tasks after the deleted one
        for i in index..<count-1 {
            let nextTask = UserDefaults.standard.string(forKey: "task_\(i + 1)")
            UserDefaults.standard.set(nextTask, forKey: "task_\(i)")
        }
        
        // Remove the last task, as it has been shifted
        UserDefaults.standard.removeObject(forKey: "task_\(count - 1)")
        
        // Update the count of tasks after deletion
        count -= 1
        UserDefaults.standard.set(count, forKey: "count")

        print("Deleted task at index \(index), new task count is \(count)")
        
        fetchAllTasks()
        // Return to the previous screen after deletion
        navigationController?.popViewController(animated: true)
    }
    
    func fetchAllTasks() {
        var tasks = [String]()
        
        // Retrieve the current task count
        let count = UserDefaults.standard.integer(forKey: "count")
        print("COUNT ---", count)
        
        // Iterate through all task keys from 0 to count - 1
        
        for x in 0..<count {
            let taskKey = "task_\(x)"
            print("TASK KEY ---", taskKey)
            if let task = UserDefaults.standard.string(forKey: taskKey) {
                print("Task found for key \(taskKey):", task)
                tasks.append(task) // Append the task to the tasks array
            } else {
                print("No task found for key \(taskKey)")
            }
        }
        
        print("ALL TASKS ---", tasks)

    }
}

