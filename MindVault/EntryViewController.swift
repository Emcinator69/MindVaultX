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
        
        //view apperance
        view.backgroundColor = .darkGray
        field.backgroundColor = .gray
        descriptionField.backgroundColor = .gray
        
        //save button for new task
        var uibarbutton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        
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
        
        //Save the time stamp
        let timestamp = Date().description(with: .current)
        UserDefaults.standard.set(timestamp, forKey: "task_timestamp_\(count)")
        
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
