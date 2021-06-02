//
//  ViewController.swift
//  Todos
//
//  Created by Minna on 04/05/21.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var tods = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }

    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("minna.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // loadItems()
        // Do any additional setup after loading the view.
    }
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tods[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        cell.accessoryType = (item.done) ? .checkmark : .none
        cell.textLabel?.text = item.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tods[indexPath.row].done = !tods[indexPath.row].done
        saveItems()

        tableView.cellForRow(at: indexPath)?.accessoryType = (tods[indexPath.row].done) ? .checkmark : .none
                
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textFiels = UITextField()
        
        let atert =  UIAlertController.init(title: "Add new ToDo", message: "", preferredStyle:.alert)
        
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textFiels.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.tods.append(newItem)
            self.saveItems()
//            DispatchQueue.main.async {
                self.tableView.reloadData()

//            }
        }
        
        atert.addAction(action)
        atert.addTextField { (textField) in
            textField.placeholder = "Add new item.."
            
            textFiels = textField
            
        }
        
        present(atert, animated: true, completion: nil)
        
    }
    //MARK: model manupulation functions
    func saveItems(){
        do{
           try context.save()
        }catch{
            print("erro \(error)")
        }
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), and predicat:NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate.init(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let predicat = predicat{
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicat])
            
            request.predicate = compoundPredicate
        }else{
            request.predicate = categoryPredicate
        }
        
        
        
        
        
        do {
           tods = try context.fetch(request)
        } catch {
            print("Error loading items\(error)")
        }
        tableView.reloadData()

    }
    
}

extension ToDoViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", search)
        let sort = NSSortDescriptor(key: "title", ascending: true)
            
            request.sortDescriptors = [sort]
           loadItems(with: request, and: predicate)
    
        
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            //refressh the table
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
