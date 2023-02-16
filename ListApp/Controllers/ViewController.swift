//
//  ViewController.swift
//  ListApp
//
//  Created by Berkay Kuzu on 16.02.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    @IBAction func barButtonItemTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "You can add an item easily :)",
                                                message: nil,
                                                preferredStyle: .alert)
        
        let defaultButton = UIAlertAction(title: "Add",
                                          style: .default) { _ in
            let text = alertController.textFields?.first?.text
            if text == "" {
                let textAlert = UIAlertController(title: "Would you mind entering an item?",
                                                  message: nil,
                                                  preferredStyle: .alert)
                let textAlertButton = UIAlertAction(title: "OK",
                                                    style: .cancel)
                textAlert.addAction(textAlertButton)
                self.present(textAlert, animated: true)
            } else {
                self.data.append((text)!)
                self.tableView.reloadData()
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        
        alertController.addTextField()
        
        alertController.addAction(defaultButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Do you really want to delete all item in the list?",
                                                message: nil,
                                                preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "Delete",
                                        style: .destructive) { _ in
            self.data.removeAll()
            self.tableView.reloadData()
        }
    
        let alertButton2 = UIAlertAction(title: "No",
                                         style: .default)
        alertController.addAction(alertButton)
        alertController.addAction(alertButton2)
        
        present(alertController, animated: true)
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

}

