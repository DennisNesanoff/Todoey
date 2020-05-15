//
//  ToDoViewController.swift
//  Todoey
//
//  Created by Dennis Nesanoff on 14.05.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    var tasks = [Task]()
    
//    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(largeTitleColor: .white,
                                    backgoundColor: .orange,
                                    tintColor: .white,
                                    title: "Todoey",
                                    preferredLargeTitle: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonPressed))
        
//        itemArray = defaults.object(forKey: "Array") as? [String] ?? [String]()
    }
    
    // MARK: - Add new items
    @objc func addButtonPressed() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            if let text = textField.text {
                
                let task = Task(title: text)
                self.tasks.insert(task, at: 0)
//                self.defaults.set(self.itemArray, forKey: "Array")
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
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
}

// MARK: - Table view data sourse
extension ToDoViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.title
        
        return cell
    }
}

// MARK: - Table view delegate
extension ToDoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tasks[indexPath.row].done = !tasks[indexPath.row].done
        tableView.cellForRow(at: indexPath)?.accessoryType = tasks[indexPath.row].done ? .checkmark : .none
    }
}
