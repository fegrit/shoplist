import SwiftUI

// Этот код отвечает за экран модификации существующего местоположения в приложении для списка покупок. Он позволяет пользователю изменить данные о выбранном местоположении, такие как его название, цвет и порядок посещения.

// Пользователь также может удалить местоположение, и если он подтверждает удаление, данные о местоположении будут удалены, а экран закроется.

struct ModifyExistingLocationView: View {
    
    @Environment(\.dismiss) var dismiss: DismissAction
    @StateObject private var draftLocation: DraftLocation
    @StateObject private var alertModel = AlertModel()

    init(location: Location) {
        _draftLocation = StateObject(wrappedValue: DraftLocation(location: location))
    }
    
    var body: some View {
        DraftLocationView(draftLocation: draftLocation) {
            alertModel.updateAndPresent(for: .confirmDeleteLocation(draftLocation.associatedLocation, { dismiss() }))
        }
        .navigationBarTitle(Text("Modify Location"), displayMode: .inline)
        .alert(alertModel.title, isPresented: $alertModel.isPresented, presenting: alertModel,
                     actions: { model in model.actions() },
                     message: { model in model.message })
        .onDisappear {
            if draftLocation.representsExistingLocation {
                Location.updateAndSave(using: draftLocation)
                PersistentStore.shared.saveContext()
            }
        }
    }
}
