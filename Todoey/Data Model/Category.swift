//
//  Category.swift
//  Todoey
//
//  Created by Nikita Dvoriadkin on 01/03/2019.
//  Copyright © 2019 Nikita Dvoriadkin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
