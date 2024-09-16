// AlertManager.swift
// MindVault

import UIKit

class AlertManager {

    private static func showAlert(on vc: UIViewController, with title: String, with message: String, closeActionTitle: String = "Close", confirmActionTitle: String, confirmActionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: closeActionTitle, style: .default, handler: nil))

        alert.addAction(UIAlertAction(title: confirmActionTitle, style: .destructive, handler: confirmActionHandler))

        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }

    public static func showDeleteConfirmation(on vc: UIViewController, confirmActionHandler: @escaping (UIAlertAction) -> Void) {
        showAlert(on: vc, with: "Are you sure you want to delete?", with: "", closeActionTitle: "Cancel", confirmActionTitle: "Delete", confirmActionHandler: confirmActionHandler)
    }
}
