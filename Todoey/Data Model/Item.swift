//
//  Item.swift
//  Todoey
//
//  Created by Nikita Dvoriadkin on 01/03/2019.
//  Copyright © 2019 Nikita Dvoriadkin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var timeCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
