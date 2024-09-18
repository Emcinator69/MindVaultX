//
//  EntryViewController.swift
//  MindVault
//
//  Created by Erik Đurkan on 14.09.2024..
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var field: UITextField!
    @IBOutlet var descriptionField: UITextField!
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        field.autocorrectionType = .no // removed autocorrect
        descriptionField.autocorrectionType = .no
        
        //apperance
        view.backgroundColor = .darkGray
        field.backgroundColor = .gray
        descriptionField.backgroundColor = .gray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveTask()
        
        return true
    }
    
    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty,
              let description = descriptionField.text else {
            return
        }
        
        // Retrieve the current task count
        let count = UserDefaults.standard.integer(forKey: "count")
        
        // Save the new task under the current count
        UserDefaults.standard.set(text, forKey: "task_\(count)")
        UserDefaults.standard.set(description, forKey: "task_description_\(count)")
        
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
