import SwiftUI

// Этот код отвечает за создание пользовательского интерфейса для редактирования информации о местоположении в списке покупок. Он позволяет пользователю изменять название, цвет и порядок посещения местоположения.

// Пользователь также может удалять местоположение и добавлять новые элементы, связанные с этим местоположением.

struct DraftLocationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var draftLocation: DraftLocation
    var deleteActionTrigger: (() -> ())?
    
    private var locationCanBeDeleted: Bool {
        draftLocation.representsExistingLocation
            && !draftLocation.associatedLocation.isUnknownLocation
    }
    
    @State private var isAddNewItemSheetShowing = false

    var body: some View {
        Form {
            Section(header: Text("Basic Information").sectionHeader()) {
                HStack {
                    SLFormLabelText(labelText: "Name: ")
                    TextField("Location name", text: $draftLocation.locationName)
                }
                
                if draftLocation.visitationOrder != kUnknownLocationVisitationOrder {
                    Stepper(value: $draftLocation.visitationOrder, in: 1...100) {
                        HStack {
                            SLFormLabelText(labelText: "Visitation Order: ")
                            Text("\(draftLocation.visitationOrder)")
                        }
                    }
                }
                
                ColorPicker("Location Color", selection: $draftLocation.color)
            }
            
            if locationCanBeDeleted {
                Section(header: Text("Location Management").sectionHeader()) {
                    SLCenteredButton(title: "Delete This Location")  {
                        deleteActionTrigger?()
                    }
                    .foregroundColor(Color.red)
                }
            }
            
            if draftLocation.representsExistingLocation {
                SimpleItemsList(location: draftLocation.associatedLocation,
                                                isAddNewItemSheetShowing: $isAddNewItemSheetShowing)
            }
            
        }
        .sheet(isPresented: $isAddNewItemSheetShowing) {
            AddNewItemView(location: draftLocation.associatedLocation) {
                isAddNewItemSheetShowing = false
            }
        }

    }

}

struct SimpleItemsList: View {
    
    @FetchRequest    private var items: FetchedResults<Item>
    @Binding var isAddNewItemSheetShowing: Bool
    
    init(location: Location, isAddNewItemSheetShowing: Binding<Bool>) {
        let request = Item.allItemsFR(at: location)
        _items = FetchRequest(fetchRequest: request)
        _isAddNewItemSheetShowing = isAddNewItemSheetShowing
    }
    
    var body: some View {
        Section(header: ItemsListHeader()) {
            ForEach(items) { item in
                NavigationLink {
                    ModifyExistingItemView(item: item)
                } label: {
                    Text(item.name)
                }
            }
        }
    }
    
    func ItemsListHeader() -> some View {
        HStack {
            Text("At this Location: \(items.count) items").sectionHeader()
            Spacer()
            Button {
                isAddNewItemSheetShowing = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}
