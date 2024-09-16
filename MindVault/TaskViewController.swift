import UIKit

class TaskViewController: UIViewController {

    @IBOutlet var label: UILabel!
    var task: String?
    var taskIndex: Int?  // Added this to track the index of the task to be deleted
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
    }
    
  /*  @objc func deleteTask() {
        // Check if the task index is set
        guard let index = taskIndex else {
            print("Task index is not set.")
            return
        }

        // Retrieve the current count of tasks
        let count = UserDefaults.standard.integer(forKey: "count")
        
        // Remove the task from UserDefaults using the task index
        UserDefaults.standard.removeObject(forKey: "task_\(index)")
        
        // Update the count of tasks after deletion
        let newCount = count - 1
        UserDefaults.standard.set(newCount, forKey: "count")

        print("Deleted task at index \(index), new task count is \(newCount)")
        
        // Return to the previous screen after deletion
        navigationController?.popViewController(animated: true)
    }*/
    
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

