import SwiftUI

class ConfirmDeleteItemAlert: IdentifiableAlertItem {
    
    init(item: Item, destructiveCompletion: (() -> Void)? = nil) {
        super.init()
        self.title = "Удалить \'\(item.name)\'?"
        self.message = "Вы уверены, что хотите удалить \'\(item.name)\'? Это действие нельзя будет отменить."
        self.destructiveAction = { Item.delete(item) }
        self.destructiveCompletion = destructiveCompletion
    }
    
}

class ConfirmMoveAllItemsOffShoppingListAlert: IdentifiableAlertItem {
    
    override init() {
        super.init()
        title = "Удалить всё"
        destructiveAction = Item.moveAllItemsOffShoppingList
    }
    
}
