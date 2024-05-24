import SwiftUI

// Этот код отвечает за экран добавления нового местоположения в приложении для списка покупок. Он позволяет пользователю ввести данные о новом местоположении, такие как его название, цвет и порядок посещения. Когда пользователь нажимает кнопку "Сохранить", введенные данные сохраняются, а экран закрывается.

// Если пользователь нажимает кнопку "Отмена", экран закрывается без сохранения данных.

struct AddNewLocationView: View {
    
    var dismiss: () -> Void
    @StateObject private var draftLocation = DraftLocation()
    
    var body: some View {
        NavigationView {
            DraftLocationView(draftLocation: draftLocation)
                .navigationBarTitle(Text("Add New Location"), displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction, content: cancelButton)
                    ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!draftLocation.canBeSaved) }
                }
                .onDisappear { PersistentStore.shared.saveContext() }
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
            dismiss()
            Location.updateAndSave(using: draftLocation)
        } label: {
            Text("Save")
        }
    }
}
