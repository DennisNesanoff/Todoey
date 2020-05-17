//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dennis Nesanoff on 16.05.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: .orange, tintColor: .white,
                                    title: "Todoey",
                                    preferredLargeTitle: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(addButtonPressed))
        loadData()
    }

    @objc func addButtonPressed() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            if let text = textField.text {
                let newCategory = Category(context: self.context)
                newCategory.name = text
                self.categories.append(newCategory)
                
                self.saveData()
//                self.tableView.reloadData()
//                let indexPath = IndexPath(row: self.categories.count, section: 0)
//                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error load context, \(error)")
        }
        
        tableView.reloadData()
    }
}

// MARK: - Table view delegate
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
}

// MARK: - Table view data sourse
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
}
