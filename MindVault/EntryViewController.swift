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

    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }

        let count = UserDefaults.standard.integer(forKey: "count")
        
        UserDefaults.standard.set(text, forKey: "task_\(count)")
        
        let newCount = count + 1
        UserDefaults.standard.set(newCount, forKey: "count")
        
        update?()
        
        navigationController?.popViewController(animated: true)
    }

}
