//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nikita Dvoriadkin on 27/02/2019.
//  Copyright © 2019 Nikita Dvoriadkin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.clear
        loadData()
    }
    
    
    
    // MARK: - Add new Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colorHex = UIColor.randomFlat.hexValue()
            
            
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
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        if let colorHexValue = categories?[indexPath.row].colorHex {
            let color = UIColor(hexString: colorHexValue)
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        }
        
        return cell
    }
    
    
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            destinationVC.navigationItem.title = categories?[indexPath.row].name
        }
        
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
        categories = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: false)

        tableView.reloadData()
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category.items)
                    realm.delete(category)
                }
            } catch {
                print("Error deleting items: \(error)")
            }
        }
    }
    
    override func editModel(at indexPath: IndexPath, with name: String) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    category.name = name
                    tableView.reloadData()
                }
            } catch {
                print("Error deleting items: \(error)")
            }
        }
    }
}
