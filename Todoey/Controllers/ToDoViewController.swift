//
//  ToDoViewController.swift
//  Todoey
//
//  Created by Dennis Nesanoff on 14.05.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: SwipeTableViewController {
    let realm = try! Realm()
    var tasks: Results<Task>?
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        
        tableView.rowHeight = 60
    }
    
    // MARK: - Add new items
    @objc func addButtonPressed() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newTask = Task()
                        newTask.title = textField.text!
                        newTask.dateCreated = Date()
                        currentCategory.tasks.append(newTask)
                        
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Load data
    func loadData() {
        tasks = selectedCategory?.tasks.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    // MARK: - Delete data
    override func updateModel(at indexPath: IndexPath) {
        if let task = self.tasks?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(task)
                }
            } catch {
                print("Error saving context, \(error)")
            }
        }
    }
}

// MARK: - Table view delegate
extension ToDoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = tasks?[indexPath.row] {
            do {
                try realm.write {
                    task.done = !task.done
                }
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Table view data sourse
extension ToDoViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let task = tasks?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No tasks added"
        }
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension ToDoViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
//        tableView.reloadData()
//        searchBar.resignFirstResponder()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
        if searchBar.text?.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
