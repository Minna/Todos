//
//  ViewController.swift
//  Todos
//
//  Created by Minna on 04/05/21.
//

import UIKit

class ToDoViewController: UITableViewController {

    var tods = [Item]()
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("minna.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
            
            let newItem = Item()
            newItem.title = textFiels.text!
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
    //MARK: modell manupulation functions
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
        
        let data = try encoder.encode(self.tods)
        
            try data.write(to: self.datafilepath!)
        }catch{
            print("erro \(error)")
        }
        
    }
    func loadItems() {
        
        if let data = try? Data(contentsOf: datafilepath!){
            
            let decoder = PropertyListDecoder()
            do{
               tods = try decoder.decode([Item].self, from: data)
            }catch{
                print("eroor while decoding\(error)")
            }
            
        }
    }
    
}

