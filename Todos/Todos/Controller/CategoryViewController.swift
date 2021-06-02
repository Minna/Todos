//
//  CategoryViewController.swift
//  Todos
//
//  Created by Minna on 02/06/21.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categoryList =  [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].name
        return cell
    }
    
 // MARK:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let desinationVC = segue.destination as! ToDoViewController
            desinationVC.selectedCategory = categoryList[tableView.indexPathForSelectedRow!.row]
        }
    }

// MARK: data manipulation
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest() )
        {
        do {
          categoryList = try context.fetch(request)

        } catch  {
            print("Error in loading data \(error)",error)
        }
         
        }
    
    func saveContect(){
        
        do {
            try context.save()
        } catch  {
            print("Error while saving data\(error)")
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alerttextfield = UITextField()
        let alert = UIAlertController.init(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) in
            
            let category = Category(context: self.context)
            category.name = alerttextfield.text
            self.categoryList.append(category)
            self.saveContect()
            
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
