//
//  ViewController.swift
//  Todoey
//
//  Created by Nikita Dvoriadkin on 10/02/2019.
//  Copyright © 2019 Nikita Dvoriadkin. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet var barButton: UIBarButtonItem!
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.placeholder = "Search"
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.tintColor = UIColor.white
        

        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(cgColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }


    override func viewDidAppear(_ animated: Bool) {
        
        if let barColor = selectedCategory?.colorHex {
            changeNavigationBarAppearance(color: UIColor(hexString: barColor)!)
            barButton.tintColor = ContrastColorOf(UIColor(hexString: barColor)!, returnFlat: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        changeNavigationBarAppearance(color: UIColor(cgColor: #colorLiteral(red: 0.328608326, green: 0.7321027848, blue: 1, alpha: 1)), dismissed: true)
    }
    
    
    
    // MARK: - DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            cell.backgroundColor = UIColor(hexString: (selectedCategory?.colorHex)!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((todoItems?.count)!))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving data: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add task", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.timeCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error ocurred with adding new item: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - Model Manipulation Methods
    
    func loadData() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "timeCreated", ascending: false)
        tableView.reloadData()
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
    
    override func editModel(at indexPath: IndexPath, with name: String) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.title = name
                    tableView.reloadData()
                }
            } catch {
                print("Error deleting items: \(error)")
            }
        }
    }

    
    // MARK: - Navigation Bar Appearance
    
    func changeNavigationBarAppearance(color: UIColor, dismissed: Bool = false) {
        
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        navigationController?.navigationBar.tintColor = ContrastColorOf(color, returnFlat: true)
        
        if dismissed {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor.black, returnFlat: true)]
        }
    }
    
}



// MARK: - Search Bar Methods

extension TodoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBarText).sorted(byKeyPath: "timeCreated", ascending: false)
        tableView.reloadData()
        
        if searchBarText.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchController.resignFirstResponder()
            }
            
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "timeCreated", ascending: false)
        tableView.reloadData()
        
        
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}
