import Foundation
import SwiftUI

// Код содержит информацию, такую как название местоположения, порядок посещения и цвет. Класс также предоставляет методы для проверки, можно ли сохранить эти данные, а также для определения, представляет ли эта информация существующее местоположение в приложении.

class DraftLocation: ObservableObject {
    var id: UUID? = nil
    @Published var locationName: String = ""
    @Published var visitationOrder: Int = 50
    @Published var color: Color = .green
    
    init(location: Location? = nil) {
        if let location = location {
            id = location.id!
            locationName = location.name
            visitationOrder = Int(location.visitationOrder)
            color = Color(location.uiColor)
        }
    }
    
    var canBeSaved: Bool { locationName.count > 0 }
    
    var representsExistingLocation: Bool { id != nil && Location.object(withID: id!) != nil }
    
    var associatedLocation: Location { Location.object(withID: id!)! }
}
