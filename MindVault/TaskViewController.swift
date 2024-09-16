import UIKit

class TaskViewController: UIViewController {

    @IBOutlet var label: UILabel!
    var task: String?
    var taskIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask() {
        
        AlertManager.showDeleteConfirmation(on: self) { _ in
            guard let index = self.taskIndex else {
                return
            }

            var count = UserDefaults.standard.integer(forKey: "count")
            
            if index >= count || index < 0 {
                return
            }
            
            UserDefaults.standard.removeObject(forKey: "task_\(index)")
            
            for i in index..<count-1 {
                let nextTask = UserDefaults.standard.string(forKey: "task_\(i + 1)")
                UserDefaults.standard.set(nextTask, forKey: "task_\(i)")
            }
            
            UserDefaults.standard.removeObject(forKey: "task_\(count - 1)")
            
            count -= 1
            UserDefaults.standard.set(count, forKey: "count")

            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func fetchAllTasks() {
        var tasks = [String]()
        
        let count = UserDefaults.standard.integer(forKey: "count")
                
        for x in 0..<count {
            let taskKey = "task_\(x)"
            if let task = UserDefaults.standard.string(forKey: taskKey) {
                tasks.append(task)
            }
        }
    }
}

