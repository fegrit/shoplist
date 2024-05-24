import SwiftUI
// Этот код определяет базовый класс `IdentifiableAlertItem`, который используется для создания и отображения предупреждающих диалоговых окон в SwiftUI. Он содержит логику для создания и настройки диалогов с возможностью выполнения разрушительных и не разрушительных действий, а также обработки их завершения.

class IdentifiableAlertItem: Identifiable {
    
    var id = UUID()
    var title: String = "Заголовок предупреждения"
    var message: String = "Предупреждение"
    
    var destructiveTitle: String = "Да"
    var destructiveAction: (() -> Void)?
    
    var nonDestructiveTitle: String = "Нет"
    var nonDestructiveAction: (() -> Void)?
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
    
    fileprivate func doDestructiveActionWithCompletion() {
        destructiveAction?()
        destructiveCompletion?()
    }
    
    fileprivate func doNonDestructiveActionWithCompletion() {
        nonDestructiveAction?()
        nonDestructiveCompletion?()
    }
    
    func alert() -> Alert {
        Alert(title: Text(title),
              message: Text(message),
              primaryButton:
                .cancel(Text(nonDestructiveTitle), action: doNonDestructiveActionWithCompletion),
              secondaryButton:
                .destructive(Text(destructiveTitle), action: doDestructiveActionWithCompletion))
    }
    
    init() { }
    
}
