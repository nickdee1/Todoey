//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Nikita Dvoriadkin on 15/03/2019.
//  Copyright © 2019 Nikita Dvoriadkin. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, index) in
            
            self.deleteModel(at: indexPath)
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, index) in
            
            var textLabel = UITextField()
            
            let alert = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (alertTextField) in
                textLabel = alertTextField
            })
            let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let alertEditAction = UIAlertAction(title: "Edit", style: .default, handler: { (editAction) in
                
                if let text = textLabel.text {
                    self.editModel(at: indexPath, with: text)
                }
                
            })
            
            
            alert.addAction(alertEditAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
    
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        options.expansionStyle = .destructive
        
        return options
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func deleteModel(at indexPath: IndexPath) {
        print("delete")
    }
    func editModel(at indexPath: IndexPath, with name: String) {
        print("edit")
    }
}
