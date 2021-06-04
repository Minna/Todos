//
//  Category.swift
//  Todos
//
//  Created by Minna on 04/06/21.
//

import Foundation
import RealmSwift

class Category: Object {
    
   @objc dynamic var name : String = ""
      var items = List<Item>()
    
}
