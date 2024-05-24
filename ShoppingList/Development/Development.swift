//
//  Development.swift
//  ShoppingList
//
//  Created by fegrit
//

// Этот файл содержит код для разработки и отладки приложения ShoppingList, включая:
// 1. Управление отображением инструментов разработчика на симуляторе и устройстве.
// 2. Логирование появления и исчезновения представлений.
// 3. Экспорт и импорт данных в формате JSON.
// 4. Вспомогательные функции и протоколы для работы с Codable.
// 5. Загрузка и сохранение данных, вставка новых элементов и местоположений в базу данных.


import Foundation
import CoreData
import UIKit

#if targetEnvironment(simulator)
    let kShowDevTools = true
#else
    let kShowDevTools = false
#endif

func logAppear(title: String) {
    print(title + " Появляется")
}

func logDisappear(title: String) {
    print(title + " Исчезает")
}

let kJSONDumpDirectory = "/Users/YOUR USERNAME HERE/Desktop/"
let kItemsFilename = "items.json"
let kLocationsFilename = "locations.json"

protocol CodableStructRepresentable {
    associatedtype DataType: Codable
    var codableProxy: DataType { get }
}

func writeAsJSON<T>(items: [T], to filename: String) where T: CodableStructRepresentable {
    let codableItems = items.map(\.codableProxy)
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    var data = Data()
    do {
        data = try encoder.encode(codableItems)
    } catch let error as NSError {
        print("Ошибка при преобразовании элементов в JSON: \(error.localizedDescription), \(error.userInfo)")
        return
    }
    
    #if targetEnvironment(simulator)
        let filepath = kJSONDumpDirectory + filename
        do {
            try data.write(to: URL(fileURLWithPath: filepath))
            print("Список элементов выгружен в формате JSON в " + filename)
        } catch let error as NSError {
            print("Не удалось записать в файл на рабочем столе: \(error.localizedDescription), \(error.userInfo)")
            print(String(data: data, encoding: .utf8)!)
        }
    #else
        print(String(data: data, encoding: .utf8)!)
    #endif
}

func populateDatabaseFromJSON() {
    let codableLocations: [LocationCodableProxy] = Bundle.main.decode(from: kLocationsFilename)
    insertNewLocations(from: codableLocations)
    let codableItems: [ItemCodableProxy] = Bundle.main.decode(from: kItemsFilename)
    insertNewItems(from: codableItems)
    PersistentStore.shared.saveContext()
}

func insertNewItems(from codableItems: [ItemCodableProxy]) {
    let locations = Location.allLocations(userLocationsOnly: true)
    let name2Location = Dictionary(grouping: locations, by: { $0.name })
    
    for codableItem in codableItems {
        let newItem = Item.addNewItem()
        newItem.name = codableItem.name
        newItem.quantity = codableItem.quantity
        newItem.onList = codableItem.onList
        newItem.isAvailable_ = codableItem.isAvailable
        newItem.dateLastPurchased_ = nil
        
        if let location = name2Location[codableItem.locationName]?.first {
            newItem.location = location
        } else {
            newItem.location = Location.unknownLocation()
        }
    }
}

func insertNewLocations(from codableLocations: [LocationCodableProxy]) {
    for codableLocation in codableLocations {
        let newLocation = Location.addNewLocation()
        newLocation.name = codableLocation.name
        newLocation.visitationOrder = codableLocation.visitationOrder
        newLocation.red_ = codableLocation.red
        newLocation.green_ = codableLocation.green
        newLocation.blue_ = codableLocation.blue
        newLocation.opacity_ = codableLocation.opacity
    }
}

extension Location: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return LocationCodableProxy(from: self)
    }
}

extension Item: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return ItemCodableProxy(from: self)
    }
}
