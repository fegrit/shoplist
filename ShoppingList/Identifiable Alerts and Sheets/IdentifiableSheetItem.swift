import SwiftUI

// Этот код представляет базовый шаблон, который позволяет создавать и отображать модальные окна в приложении, написанном на SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

class IdentifiableSheetItem: Identifiable {
    
    var id = UUID()
    
    func content() -> AnyView {
        return EmptyView().eraseToAnyView()
    }
}
