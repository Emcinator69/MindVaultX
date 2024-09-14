//
//  EntryViewController.swift
//  MindVault
//
//  Created by Erik Đurkan on 14.09.2024..
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var field: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveTask()
        
        return true
    }

    @IBAction func saveTask(){
        
    }

}
