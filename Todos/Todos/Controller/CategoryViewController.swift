//
//  CategoryViewController.swift
//  Todos
//
//  Created by Minna on 02/06/21.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    
    var categoryList : Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No category added"
        return cell
    }
    
 // MARK:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let desinationVC = segue.destination as! ToDoViewController
            desinationVC.selectedCategory = categoryList?[tableView.indexPathForSelectedRow!.row]
        }
    }

// MARK: data manipulation
    func loadCategories()
        {
        
        categoryList = realm.objects(Category.self)
        tableView.reloadData()
        }
    
func saveCategories(category: Category){
        
        do {
            try realm.write{
                
                realm.add(category)
            }
            
        } catch  {
            print("Error while saving data\(error)")
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alerttextfield = UITextField()
        let alert = UIAlertController.init(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) in
            
            let category = Category()
            category.name = alerttextfield.text!
            self.saveCategories(category: category)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add new item.."
            alerttextfield = textField
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
