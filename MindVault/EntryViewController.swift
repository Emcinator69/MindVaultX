//
//  EntryViewController.swift
//  MindVault
//
//  Created by Erik Đurkan on 14.09.2024..
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveTask()
        
        return true
    }
/*@objc func saveTask(){
 guard let text = field.text, !text.isEmpty else {
     return
 }
 
 // Retrieve the current task count, or default to 0 if it doesn't exist
 let count = UserDefaults.standard.integer(forKey: "count")
 
 // Save the new task under the current count
 UserDefaults.standard.set(text, forKey: "task_\(count)")
 
 // Increment the count and save it back to UserDefaults
 let newCount = count + 1
 UserDefaults.standard.set(newCount, forKey: "count")
 
 print("Saved task under task_\(count), new count is \(newCount)")

 // Notify the view to update
 update?()
 
 // Pop the view controller
 navigationController?.popViewController(animated: true)
}
*/
    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }

        // Retrieve the current task count
        let count = UserDefaults.standard.integer(forKey: "count")
        
        // Save the new task under the current count
        UserDefaults.standard.set(text, forKey: "task_\(count)")
        
        // Increment the count and save it back to UserDefaults
        let newCount = count + 1
        UserDefaults.standard.set(newCount, forKey: "count")
        
        print("Saved task under task_\(count), new count is \(newCount)")

        // Notify the view to update
        update?()
        
        // Pop the view controller
        navigationController?.popViewController(animated: true)
    }


}
