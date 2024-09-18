//
//  ViewController.swift
//  MindVault
//
//  Created by Erik Đurkan on 14.09.2024..
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        self.tableView.backgroundColor = .gray
        
        
        
        self.title = "All Tasks"
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup
        if !UserDefaults.standard.bool(forKey: "setup") {
            UserDefaults.standard.set(true, forKey: "setup")
            UserDefaults.standard.set(Int(0), forKey: "count")
        }
        // Get all current saved tasks
        updateTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTasks()
    }
    
  //kikiriki
   func updateTasks() {
        tasks.removeAll()
        
        // Retrieve the current task count
        let count = UserDefaults.standard.integer(forKey: "count")
        print("COUNT ---", count)
        
        // Only iterate if the count is greater than 0
        if count > 0 {
            
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
        }
        
        print("ALL TASKS ---", tasks)
        tableView.reloadData()
    }


    
    @IBAction func didTapAdd(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "New Task"
        
        vc.update = {
            DispatchQueue.main.async{
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "task") as! TaskViewController
        vc.title = tasks[indexPath.row]
        vc.task = tasks[indexPath.row]
        vc.taskIndex = indexPath.row
        
        navigationController?.pushViewController(vc, animated: true)
        }
       
    }


extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        cell.backgroundColor = UIColor.gray
        return cell
    }
}
