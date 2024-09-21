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
    
    func updateTasks() {
        tasks.removeAll()
        
        // Retrieve the current task count
        let count = UserDefaults.standard.integer(forKey: "count")
        print("COUNT ---", count)
        
        if count > 0 {
            for x in 0..<count {
                let taskKey = "task_\(x)"
                let timestampKey = "task_timestamp_\(x)"
                
                print("TASK KEY ---", taskKey)
                
                if let task = UserDefaults.standard.string(forKey: taskKey) {
                    // Retrieve timestamp
                    let timestamp = UserDefaults.standard.string(forKey: timestampKey)
                    
                    // Append the task with its timestamp
                    let taskWithTimestamp: String
                    if let timestamp = timestamp {
                        taskWithTimestamp = "\(task) (\(timestamp))"
                    } else {
                        taskWithTimestamp = "\(task) (Created at: No timestamp)"
                    }
                    
                    print("Task found for key \(taskKey):", taskWithTimestamp)
                    tasks.append(taskWithTimestamp)
                    
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

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Split the task and timestamp
        let taskString = tasks[indexPath.row]
        let components = taskString.split(separator: "(", maxSplits: 1, omittingEmptySubsequences: false)
        
        let taskTitle = components[0].trimmingCharacters(in: .whitespaces)
        let timestampString = components.count > 1 ? "(" + components[1] : nil
        
        // Create attributed string
        let attributedString = NSMutableAttributedString(string: taskTitle)
        if let timestampString = timestampString {
            let timestampAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 8) // Smaller font size for the timestamp
            ]
            let timestampAttributedString = NSAttributedString(string: timestampString, attributes: timestampAttributes)
            attributedString.append(timestampAttributedString)
        }
        
        // Set the attributed text
        cell.textLabel?.attributedText = attributedString
        cell.backgroundColor = UIColor.gray
        
        return cell
    }
}



