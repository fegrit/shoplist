import Foundation

// Этот код представляет класс `DraftItem`, который используется для сбора данных о товаре, который может быть изменен или отображен. Класс предоставляет значения по умолчанию для нового товара при создании и может быть инициализирован данными из объекта `Item`. Этот класс используется в представлениях для редактирования или отображения информации о товаре.

class DraftItem: ObservableObject {
        
    var id: UUID? = nil
    @Published var name: String = ""
    @Published var quantity: Int = 1
    @Published var location = Location.unknownLocation()
    @Published var onList: Bool = true
    @Published var isAvailable = true
    var dateText = ""
    
    init(item: Item) {
        id = item.id
        name = item.name
        quantity = Int(item.quantity)
        location = item.location
        onList = item.onList
        isAvailable = item.isAvailable
        if item.hasBeenPurchased {
            dateText = item.dateLastPurchased.formatted(date: .long, time: .omitted)
        } else {
            dateText = "(Never)"
        }
    }
    
    init(initialItemName: String?, location: Location? = nil) {
        if let name = initialItemName, name.count > 0 {
            self.name = name
        }
        if let location = location {
            self.location = location
        }
    }
    
    var canBeSaved: Bool { name.count > 0 }
    var representsExistingItem: Bool { id != nil && Item.object(withID: id!) != nil }
    var associatedItem: Item { Item.object(withID: id!)! }
}
