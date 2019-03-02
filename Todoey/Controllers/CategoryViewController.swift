//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nikita Dvoriadkin on 27/02/2019.
//  Copyright © 2019 Nikita Dvoriadkin. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            if let category = self.categoryArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(category.items)
                        self.realm.delete(category)
                    }
                } catch {
                    print("Error deleting category: \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, index) in
            var textField = UITextField()
            let alert = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) in
                if let category = self.categoryArray?[indexPath.row] {
                    do {
                        try self.realm.write {
                            category.name = textField.text!
                        }
                    } catch {
                        print("Error editing name: \(error)")
                    }
                }
                self.tableView.reloadData()
            })
            
            alert.addTextField(configurationHandler: { (textFieldAction) in
                textField = textFieldAction
            })
            alert.addAction(cancelAction)
            alert.addAction(submitAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        edit.backgroundColor = UIColor(ciColor: .blue)
        
        return [delete, edit]
    }
    
    // MARK: - Data Manipulation methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error occured with saving data: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData() {
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
}
