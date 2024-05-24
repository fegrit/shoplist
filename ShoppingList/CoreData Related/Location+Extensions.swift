import UIKit
import CoreData

let kUnknownLocationName = "Unknown Location"
let kUnknownLocationVisitationOrder: Int32 = INT32_MAX

extension Location: Comparable {
    public static func < (lhs: Location, rhs: Location) -> Bool {
        lhs.visitationOrder_ < rhs.visitationOrder_
    }

    var name: String {
        get { name_ ?? "Unknown Name" }
        set {
            name_ = newValue
            items.forEach({ $0.objectWillChange.send() })
        }
    }

    var visitationOrder: Int {
        get { Int(visitationOrder_) }
        set {
            visitationOrder_ = Int32(newValue)
            items.forEach({ $0.objectWillChange.send() })
        }
    }

    var items: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: \.name)
        }
        return []
    }

    var itemCount: Int { items_?.count ?? 0 }

    var isUnknownLocation: Bool { visitationOrder_ == kUnknownLocationVisitationOrder }

    var uiColor: UIColor {
        get {
            UIColor(red: red_, green: green_, blue: blue_, alpha: opacity_)
        }
        set {
            if let components = newValue.cgColor.components {
                items.forEach({ $0.objectWillChange.send() })
                red_ = components[0]
                green_ = components[1]
                blue_ = components[2]
                opacity_ = components[3]
            }
        }
    }

    class func allLocationsFR(onList: Bool = false) -> NSFetchRequest<Location> {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "visitationOrder_", ascending: true)]
        if onList {
            request.predicate = NSPredicate(format: "ANY items_.onList_ == true")
        }
        return request
    }

    class func count() -> Int {
        return count(context: PersistentStore.shared.context)
    }

    class func allLocations(userLocationsOnly: Bool) -> [Location] {
        var allLocations = allObjects(context: PersistentStore.shared.context) as! [Location]
        if userLocationsOnly {
            if let index = allLocations.firstIndex(where: { $0.isUnknownLocation }) {
                allLocations.remove(at: index)
            }
        }
        return allLocations
    }

    class func addNewLocation() -> Location {
        let newLocation = Location(context: PersistentStore.shared.context)
        newLocation.id = UUID()
        return newLocation
    }

    private class func createUnknownLocation() -> Location {
        let unknownLocation = addNewLocation()
        unknownLocation.name_ = kUnknownLocationName
        unknownLocation.red_ = 0.5
        unknownLocation.green_ = 0.5
        unknownLocation.blue_ = 0.5
        unknownLocation.opacity_ = 0.5
        unknownLocation.visitationOrder_ = kUnknownLocationVisitationOrder
        return unknownLocation
    }

    class func unknownLocation() -> Location {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "visitationOrder_ == %d", kUnknownLocationVisitationOrder)
        do {
            let locations = try PersistentStore.shared.context.fetch(fetchRequest)
            if locations.count >= 1 {
                return locations[0]
            } else {
                return createUnknownLocation()
            }
        } catch let error as NSError {
            fatalError("Error fetching unknown location: \(error.localizedDescription), \(error.userInfo)")
        }
    }

    class func delete(_ location: Location) {
        guard location != Location.unknownLocation() else { return }

        let itemsAtThisLocation = location.items
        let theUnknownLocation = Location.unknownLocation()
        itemsAtThisLocation.forEach({ $0.location = theUnknownLocation })

        let context = PersistentStore.shared.context
        context.delete(location)
        PersistentStore.shared.saveContext()
    }

    class func updateAndSave(using draftLocation: DraftLocation) {
        if let id = draftLocation.id,
             let location = Location.object(id: id, context: PersistentStore.shared.context) {
            location.updateValues(from: draftLocation)
        } else {
            let newLocation = Location.addNewLocation()
            newLocation.updateValues(from: draftLocation)
        }
        PersistentStore.shared.saveContext()
    }

    class func object(withID id: UUID) -> Location? {
        return object(id: id, context: PersistentStore.shared.context) as Location?
    }

    func updateValues(from draftLocation: DraftLocation) {
        name_ = draftLocation.locationName
        visitationOrder_ = Int32(draftLocation.visitationOrder)
        if let components = draftLocation.color.cgColor?.components {
            red_ = Double(components[0])
            green_ = Double(components[1])
            blue_ = Double(components[2])
            opacity_ = Double(components[3])
        } else {
            red_ = 0.0
            green_ = 1.0
            blue_ = 0.0
            opacity_ = 0.5
        }
        items.forEach({ $0.objectWillChange.send() })
    }
}
