import Foundation
import CoreData
import UIKit

extension Item {
    var name: String {
        get { name_ ?? "Без названия" }
        set { name_ = newValue }
    }

    var isAvailable: Bool {
        get { isAvailable_ }
        set { isAvailable_ = newValue }
    }

    var onList: Bool {
        get { onList_ }
        set {
            onList_ = newValue
            if !onList_ {
                dateLastPurchased_ = Date()
            }
        }
    }

    var quantity: Int {
        get { Int(quantity_) }
        set { quantity_ = Int32(newValue) }
    }

    var location: Location {
        get {
            if let location = location_ {
                return location
            }
            location_ = Location.unknownLocation()
            return location_!
        }
        set {
            location_?.objectWillChange.send()
            location_ = newValue
            location_?.objectWillChange.send()
        }
    }

    var dateLastPurchased: Date { dateLastPurchased_ ?? Date(timeIntervalSinceReferenceDate: 1) }

    var hasBeenPurchased: Bool { dateLastPurchased_ != nil }

    var locationName: String { location_?.name_ ?? "Недоступно" }

    var uiColor: UIColor {
        location_?.uiColor ?? UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    }

    var canBeSaved: Bool {
        guard let name = name_ else { return false }
        return name.count > 0
    }

    class func allItemsFR(at location: Location) -> NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "location_ == %@", location)
        return request
    }

    class func allItemsFR(onList: Bool) -> NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "onList_ == %d", onList)
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }

    class func count() -> Int {
        return count(context: PersistentStore.shared.context)
    }

    class func allItems() -> [Item] {
        return allObjects(context: PersistentStore.shared.context) as! [Item]
    }

    class func object(withID id: UUID) -> Item? {
        return object(id: id, context: PersistentStore.shared.context) as Item?
    }

    class func addNewItem() -> Item {
        let context = PersistentStore.shared.context
        let newItem = Item(context: context)
        newItem.name = ""
        newItem.quantity = 1
        newItem.isAvailable = true
        newItem.onList = true
        newItem.id = UUID()
        newItem.location = Location.unknownLocation()
        return newItem
    }

    class func updateAndSave(using draftItem: DraftItem) {
        if let id = draftItem.id,
            let item = Item.object(id: id, context: PersistentStore.shared.context) {
            item.updateValues(from: draftItem)
        } else {
            let newItem = Item.addNewItem()
            newItem.updateValues(from: draftItem)
        }
        PersistentStore.shared.saveContext()
    }

    class func delete(_ item: Item) {
        if let location = item.location_ {
            location.objectWillChange.send()
        }
        item.location_ = nil

        let context = PersistentStore.shared.context
        context.delete(item)
        PersistentStore.shared.saveContext()
    }

    class func moveAllItemsOffShoppingList() {
        for item in allItems() where item.onList {
            item.onList_ = false
        }
    }

    func toggleAvailableStatus() {
        isAvailable.toggle()
        PersistentStore.shared.saveContext()
    }

    func toggleOnListStatus() {
        onList = !onList
        PersistentStore.shared.saveContext()
    }

    func markAvailable() {
        isAvailable_ = true
        PersistentStore.shared.saveContext()
    }

    private func updateValues(from draftItem: DraftItem) {
        name_ = draftItem.name
        quantity_ = Int32(draftItem.quantity)
        onList_ = draftItem.onList
        isAvailable_ = draftItem.isAvailable
        location = draftItem.location
    }
}
