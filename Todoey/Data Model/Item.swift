//
//  ItemModel.swift
//  Todoey
//
//  Created by Nikita Dvoriadkin on 15/02/2019.
//  Copyright © 2019 Nikita Dvoriadkin. All rights reserved.
//

import Foundation

class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
