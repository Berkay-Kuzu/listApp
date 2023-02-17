//
//  ViewController.swift
//  ListApp
//
//  Created by Berkay Kuzu on 16.02.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [NSManagedObject]()
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        fetch()
    }
    
    @IBAction func barButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAddAlert()
        
    }
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAlert(titleInput: "Do you really want to delete all the item in the list?",
                     messageIntput: nil,
                     cancelAlertButtonInput: "Cancel",
                     defaultButtonTitleInput: "Delete") { _ in
            //self.data.removeAll()
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
                        
                        for item in self.data {
                            managedObjectContext?.delete(item)
                        }
                        
                        try? managedObjectContext?.save()
                        
            
            self.fetch()
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
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ListItem",
                                                        in: managedObjectContext!)
                
                let listItem = NSManagedObject(entity: entity!,
                                                        insertInto: managedObjectContext)
                    
                    listItem.setValue(text, forKey: "title")
                    
                      try? managedObjectContext?.save()
                    
                    self.fetch()
                
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
    
    func fetch () {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        data = try! managedObjectContext!.fetch(fetchRequest)
        
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { _, _, _ in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            managedObjectContext?.delete(self.data[indexPath.row])
            try? managedObjectContext?.save()
            
            self.fetch()
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
                    //self.data[indexPath.row] = text!
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    self.data[indexPath.row].setValue(text, forKey: "title")
                    
                    if managedObjectContext!.hasChanges {
                        try? managedObjectContext?.save()
                    }

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

