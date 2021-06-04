//
//  ViewController.swift
//  Todos
//
//  Created by Minna on 04/05/21.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var tods: Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }

   let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tods?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)

        if let item = tods?[indexPath.row]{
        cell.accessoryType = item.done ? .checkmark : .none
        cell.textLabel?.text = item.title
        }else{
            cell.textLabel?.text = "Not item added yet."

        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = tods?[indexPath.row]{
            
            do{
                try self.realm.write {
                    
                    item.done = !item.done
                   
                }
            }catch{
                print("erro \(error)")
            }
        
        
//        tods[indexPath.row].done = !tods[indexPath.row].done
//        saveItems()
//
        tableView.cellForRow(at: indexPath)?.accessoryType = (item.done) ? .checkmark : .none

        tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textFiels = UITextField()

        let atert =  UIAlertController.init(title: "Add new ToDo", message: "", preferredStyle:.alert)

        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
                
                
                do{
                    try self.realm.write {
                        
                        
                            let newItem = Item()
                            newItem.title = textFiels.text!
                            currentCategory.items.append(newItem)
                       
                    }
                }catch{
                    print("erro \(error)")
                }

            }
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
    func saveItems(_ item:Item){
       
    }
    
    func loadItems() {

        tods = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        let categoryPredicate = NSPredicate.init(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let predicat = predicat{
//            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicat])
//
//            request.predicate = compoundPredicate
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//
//
//
//
//        do {
//           tods = try context.fetch(request)
//        } catch {
//            print("Error loading items\(error)")
//        }
//        tableView.reloadData()
//
    }
    
}

//extension ToDoViewController: UISearchBarDelegate
//{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if let search = searchBar.text {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", search)
//        let sort = NSSortDescriptor(key: "title", ascending: true)
//
//            request.sortDescriptors = [sort]
//           loadItems(with: request, and: predicate)
//
//
//        }
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.count == 0{
//            //refressh the table
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
