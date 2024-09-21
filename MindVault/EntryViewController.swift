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
        self.navigationController?.navigationBar.tintColor = .black
        
        field.autocorrectionType = .no // removed autocorrect
        descriptionField.autocorrectionType = .no
        //View Appearance
        view.backgroundColor = .darkGray
        field.backgroundColor = .gray
        descriptionField.backgroundColor = .gray
        
        // BLACK BORDER TO TITLE INPUT BOX
        field.layer.borderColor = UIColor.black.cgColor // Set border color to black
        field.layer.borderWidth = 1.0 // Set border width
        
        // BLACK BORDER TO DESCRIPTION INPUT BOX
        descriptionField.layer.borderColor = UIColor.black.cgColor // Set border color to black
        descriptionField.layer.borderWidth = 1.0 // Set border width
        
        //save button for new task
        let uibarbutton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        
        navigationItem.rightBarButtonItem = uibarbutton
        uibarbutton.tintColor = .black
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
        
        // Save the current timestamp when the task is created
        let dateFormatter = DateFormatter() // Create a DateFormatter instance
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Set the desired date format
        let timestamp = dateFormatter.string(from: Date()) // Format the current date
        UserDefaults.standard.set(timestamp, forKey: "task_timestamp_\(count)") // Save formatted timestamp
        
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
