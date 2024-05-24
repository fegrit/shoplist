//
//  ItemCodable.swift
//  ShoppingList
//
//  Created by fegrit.
//  Copyright © fegrit. All rights reserved.
//

import Foundation

// Этот файл содержит структуру для кодирования и декодирования объектов Item в JSON формате.

struct ItemCodableProxy: Codable {
    var name: String
    var onList: Bool
    var isAvailable: Bool
    var quantity: Int
    var locationName: String
    
    init(from item: Item) {
        name = item.name
        onList = item.onList
        isAvailable = item.isAvailable
        quantity = item.quantity
        locationName = item.locationName
    }
}
