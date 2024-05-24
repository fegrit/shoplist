import SwiftUI

// Этот код отвечает за представление формы редактирования данных о товаре в списке покупок. Он позволяет пользователю изменить основные характеристики товара, такие как название, количество, местоположение и его статус наличия в списке покупок. Кроме того, если товар уже существует в списке, пользователь может удалить его, нажав на кнопку "Delete This Shopping Item".

struct DraftItemView: View {

    @ObservedObject var draftItem: DraftItem
    var deleteActionInitiator: (() -> ())?
    private var itemExists: Bool {
        deleteActionInitiator != nil
    }

    @FetchRequest(fetchRequest: Location.allLocationsFR())
    private var locations: FetchedResults<Location>
        
    var body: some View {
        Form {
            Section(header: Text("Basic Information").sectionHeader()) {
                HStack(alignment: .firstTextBaseline) {
                    SLFormLabelText(labelText: "Name: ")
                    TextField("Item name", text: $draftItem.name)
                }
                
                Stepper(value: $draftItem.quantity, in: 1...10) {
                    HStack {
                        SLFormLabelText(labelText: "Quantity: ")
                        Text("\(draftItem.quantity)")
                    }
                }
                
                Picker(selection: $draftItem.location, label: SLFormLabelText(labelText: "Location: ")) {
                    ForEach(locations) { location in
                        Text(location.name).tag(location)
                    }
                }
                
                HStack(alignment: .firstTextBaseline) {
                    Toggle(isOn: $draftItem.onList) {
                        SLFormLabelText(labelText: "On Shopping List: ")
                    }
                }
                
                HStack(alignment: .firstTextBaseline) {
                    Toggle(isOn: $draftItem.isAvailable) {
                        SLFormLabelText(labelText: "Is Available: ")
                    }
                }
                
                if itemExists {
                    HStack(alignment: .firstTextBaseline) {
                        SLFormLabelText(labelText: "Last Purchased: ")
                        Text("\(draftItem.dateText)")
                    }
                }
            }
            
            if itemExists {
                Section(header: Text("Shopping Item Management").sectionHeader()) {
                    SLCenteredButton(title: "Delete This Shopping Item") {
                        deleteActionInitiator?()
                    }
                    .foregroundColor(Color.red)
                }
            }
        }
    }
}
