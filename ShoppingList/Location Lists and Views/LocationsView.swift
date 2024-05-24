import SwiftUI

// Этот код отображает экран со списком мест, где вы обычно делаете покупки (Locations). Вы можете видеть список мест, добавлять новые места и удалять старые. Каждое место имеет свою страницу, где вы можете внести изменения, если это необходимо.

struct LocationsView: View {
    
    @FetchRequest(fetchRequest: Location.allLocationsFR())
    private var locations: FetchedResults<Location>
    
    @State private var identifiableSheetItem: IdentifiableSheetItem?
    @StateObject private var alertModel = AlertModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            Rectangle()
                .frame(height: 1)
            
            List {
                Section(header: Text("Locations Listed: \(locations.count)").sectionHeader()) {
                    ForEach(locations) { location in
                        NavigationLink {
                            ModifyExistingLocationView(location: location)
                        } label: {
                            LocationRowView(rowData: LocationRowData(location: location))
                        }
                    }
                    .onDelete(perform: deleteLocations)
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            Divider()
        }
        .navigationBarTitle("Locations")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: addNewButton)
        }
        .alert(alertModel.title, isPresented: $alertModel.isPresented, presenting: alertModel,
                     actions: { model in model.actions() },
                     message: { model in model.message })
        .sheet(item: $identifiableSheetItem) { item in item.content() }
        .onAppear {
            logAppear(title: "LocationsTabView")
            handleOnAppear()
        }
        .onDisappear() {
            logDisappear(title: "LocationsTabView")
            PersistentStore.shared.saveContext()
        }
    }
    
    func deleteLocations(at offsets: IndexSet) {
        guard let firstIndex = offsets.first else { return }
        let location = locations[firstIndex]
        if !location.isUnknownLocation {
            alertModel.updateAndPresent(for: .confirmDeleteLocation(location, nil))
        }
    }
    
    func handleOnAppear() {
        if locations.count == 0 {
            let _ = Location.unknownLocation()
        }
    }
    
    func addNewButton() -> some View {
        Button {
            identifiableSheetItem = AddNewLocationSheetItem(dismiss: { identifiableSheetItem = nil })
        } label: {
            Image(systemName: "plus")
        }
    }
}
