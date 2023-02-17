//
//  ViewController.swift
//  ListApp
//
//  Created by Berkay Kuzu on 16.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [String]()
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func barButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAddAlert()
        
    }
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAlert(titleInput: "Do you really want to delete all the item in the list?",
                     messageIntput: nil,
                     cancelAlertButtonInput: "Cancel",
                     defaultButtonTitleInput: "Delete") { _ in
            self.data.removeAll()
            self.tableView.reloadData()
        }
    }
    
    // to delete an item in the row!
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //        return .delete
    //    }
    //
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            tableView.beginUpdates()
    //            data.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //            tableView.endUpdates()
    //        }
    //    }
    
    func presentAddAlert() {
        
        presentAlert(titleInput: "You can add an item easily",
                     messageIntput: nil,
                     cancelAlertButtonInput: "Cancel",
                     defaultButtonTitleInput: "Add",
                     isTextFieldAvailable: true) { _ in
            let text = self.alertController.textFields?.first?.text
            if text != "" {
                self.data.append((text)!)
                self.tableView.reloadData()
                
            } else {
                self.presentWarningAlert()
            }
        }
    }
    
    func presentWarningAlert() {
        
        presentAlert(titleInput: "Would you mind entering an item?",
                     messageIntput: nil,
                     cancelAlertButtonInput: "OK")
    }
    
    func presentAlert(titleInput : String?,
                      messageIntput: String?,
                      prefferedStyleInput: UIAlertController.Style = .alert,
                      cancelAlertButtonInput: String?,
                      defaultButtonTitleInput: String? = nil,
                      isTextFieldAvailable : Bool = false,
                      defaultButtonHandlerInput: ((UIAlertAction) -> Void)? = nil ) {
        
        alertController = UIAlertController(title: titleInput,
                                            message: messageIntput,
                                            preferredStyle: prefferedStyleInput)
        
        if defaultButtonTitleInput != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitleInput,
                                              style: .default,
                                              handler: defaultButtonHandlerInput)
            alertController.addAction(defaultButton)
        }
        
        
        let cancelButton = UIAlertAction(title: cancelAlertButtonInput,
                                         style: .default)
        
        if isTextFieldAvailable {
            alertController.addTextField()
        }
        
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { _, _, _ in
            self.data.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit") { _, _, _ in
            self.presentAlert(titleInput: "You can edit an item easily",
                         messageIntput: nil,
                         cancelAlertButtonInput: "Cancel",
                         defaultButtonTitleInput: "Edit",
                         isTextFieldAvailable: true) { _ in
                let text = self.alertController.textFields?.first?.text
                if text != "" {
                    self.data[indexPath.row] = text!
                    self.tableView.reloadData()
                    
                } else {
                    self.presentWarningAlert()
                }
            }
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return config
    }
    
}

