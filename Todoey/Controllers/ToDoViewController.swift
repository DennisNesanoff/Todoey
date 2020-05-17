//
//  ToDoViewController.swift
//  Todoey
//
//  Created by Dennis Nesanoff on 14.05.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoViewController: UITableViewController {
    @IBOutlet var searchBar: UISearchBar!
    var tasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: CategoryRealm? {
        didSet {
//            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: .orange, tintColor: .white,
                                    title: "Tasks",
                                    preferredLargeTitle: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(addButtonPressed))
        searchBar.delegate = self
    }
    
    // MARK: - Add new items
    @objc func addButtonPressed() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            if let text = textField.text {
                let newTask = Task(context: self.context)
                newTask.title = text
                newTask.done = false
//                newTask.parentCategory = self.selectedCategory
                
                self.tasks.insert(newTask, at: 0)
                
//                self.saveData()
                
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
    
//    func saveData() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context, \(error)")
//        }
//    }

//    func loadData(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//        tasks = try context.fetch(request)
//        } catch {
//            print("Error load context, \(error)")
//        }
//
//        tableView.reloadData()
//    }
}

// MARK: - Table view delegate
extension ToDoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].done = !tasks[indexPath.row].done
//        saveData()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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
        cell.accessoryType = task.done ? .checkmark : .none
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

//        loadData(with: request, predicate: predicate)
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadData(with: request, predicate: predicate)
        
        if searchBar.text?.count == 0 {
//            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
