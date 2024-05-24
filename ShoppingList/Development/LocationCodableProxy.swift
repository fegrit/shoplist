//
//  LocationJSON.swift
//  ShoppingList
//
//  Created by fegrit.
//  Copyright © fegrit. All rights reserved.
//

import Foundation

// Этот файл содержит структуру для кодирования и декодирования объектов Location в JSON формате.

struct LocationCodableProxy: Codable {
    var name: String
    var visitationOrder: Int
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(from location: Location) {
        name = location.name
        visitationOrder = location.visitationOrder
        red = location.red_
        green = location.green_
        blue = location.blue_
        opacity = location.opacity_
    }
}
