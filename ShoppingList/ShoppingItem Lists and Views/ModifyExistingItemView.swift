import SwiftUI

// Этот код отвечает за представление экрана редактирования существующего элемента списка покупок. Он позволяет пользователю изменить данные о товаре, такие как название, местоположение и другие характеристики.
// Пользователь может также удалить элемент из списка, при этом отображается предупреждение для подтверждения действия. Кроме того, код обрабатывает сохранение изменений и возврат к предыдущему экрану.

struct ModifyExistingItemView: View {

    @Environment(\.dismiss) private var dismiss: DismissAction
    @StateObject private var draftItem: DraftItem

    init(item: Item) {
        _draftItem = StateObject(wrappedValue: DraftItem(item: item))
    }

    @State private var confirmDeleteItemAlert: IdentifiableAlertItem?
    @State private var confirmDeleteAlertShowing = false

    var body: some View {
        DraftItemView(draftItem: draftItem) {
            confirmDeleteItemAlert = ConfirmDeleteItemAlert(item: draftItem.associatedItem) {
                dismiss()
            }
        }
        .navigationBarTitle(Text("Modify Item"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: customBackButton)
        }
        .alert(item: $confirmDeleteItemAlert) { item in item.alert() }
    }

    func customBackButton() -> some View {
        Button {
            if draftItem.representsExistingItem {
                Item.updateAndSave(using: draftItem)
            }
            dismiss()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
}
