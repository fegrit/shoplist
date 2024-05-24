import SwiftUI

// Этот код определяет два класса, `AddNewLocationSheetItem` и `AddNewItemSheetItem`, которые представляют собой шаблоны для отображения модальных окон в приложении.

//Каждый из этих классов предназначен для отображения определенного вида контента в модальном окне. Например, `AddNewLocationSheetItem` используется для отображения формы добавления нового местоположения, а `AddNewItemSheetItem` - для отображения формы добавления нового элемента. 

// Классы содержат логику для создания и отображения соответствующих представлений в модальном окне, а также функции для закрытия модального окна после завершения операции.

class AddNewLocationSheetItem: IdentifiableSheetItem {
    
    private var dismiss: () -> Void
    
    init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
        super.init()
    }
    
    override func content() -> AnyView {
        AddNewLocationView(dismiss: dismiss)
            .eraseToAnyView()
    }
    
}

class AddNewItemSheetItem: IdentifiableSheetItem {
    
    private var dismiss: () -> Void
    
    init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
        super.init()
    }
    
    override func content() -> AnyView {
        AddNewItemView(dismiss: dismiss)
            .eraseToAnyView()
    }
    
}
