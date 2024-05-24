import SwiftUI

struct AddNewItemView: View {

    private var dismiss: () -> Void
    @StateObject private var draftItem: DraftItem

    init(initialItemName: String? = nil, location: Location? = nil, dismiss: @escaping () -> Void) {
        let initialValue = DraftItem(initialItemName: initialItemName, location: location)
        _draftItem = StateObject(wrappedValue: initialValue)
        self.dismiss = dismiss
    }

    var body: some View {
        NavigationView {
            DraftItemView(draftItem: draftItem)
                .navigationBarTitle("Add New Item", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction, content: cancelButton)
                    ToolbarItem(placement: .confirmationAction, content: saveButton)
                }
        }
    }

    func cancelButton() -> some View {
        Button {
            dismiss()
        } label: {
            Text("Cancel")
        }
    }

    func saveButton() -> some View {
        Button {
            Item.updateAndSave(using: draftItem)
            dismiss()
        } label: {
            Text("Save")
        }
        .disabled(!draftItem.canBeSaved)
    }
}
