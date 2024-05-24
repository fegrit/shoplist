import SwiftUI

// Этот код определяет способ отображения и управления предупреждающими диалоговыми окнами в приложении. Он использует класс `AlertModel`, чтобы создавать и показывать диалоговые окна с различными сообщениями и действиями. Это позволяет приложению задавать пользователю вопросы или запрашивать подтверждение перед выполнением определенных действий, таких как удаление элементов или подтверждение действий.

enum AlertModelType {
    case none
    case confirmDeleteLocation(Location, (() -> Void)?)
}

class AlertModel: ObservableObject {
    
    @Published var isPresented = false
    
    var title = ""
    var message = Text("")
    
    var destructiveTitle: String = "OK"
    var destructiveAction: (() -> Void)?
    
    @ViewBuilder
    func actions() -> some View {
        Button(destructiveTitle, role: .destructive) { [self] in
            destructiveAction?()
        }
    }
    
    func updateAndPresent(for type: AlertModelType) {
        switch type {
            
            case .none:
                return
                
            case .confirmDeleteLocation(let location, let completion):
                title = "Удалить \'\(location.name)\'?"
                message = Text("Вы уверены, что хотите удалить магазин: \'\(location.name)\'? Все товары из этого магазина будут перемещены в Неизвестный магазин. Это действие нельзя отменить.")
                destructiveAction = {
                    Location.delete(location)
                    completion?()
                }
        }
        isPresented = true
    }
    
}
