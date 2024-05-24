import SwiftUI

struct PurchasedItemsView: View {
    
    @FetchRequest(fetchRequest: Item.allItemsFR(onList: false))
    private var items: FetchedResults<Item>
    
    @State private var searchText: String = ""
    @State private var identifiableAlertItem: IdentifiableAlertItem?
    @State private var identifiableSheetItem: IdentifiableSheetItem?
    @State var multiSectionDisplay: Bool = false
    @EnvironmentObject var today: Today
    @State private var itemsChecked = [Item]()
    @AppStorage(wrappedValue: 3, "PurchasedHistoryMarker") private var historyMarker
    
    var body: some View {
        VStack(spacing: 0) {
            
            Rectangle()
                .frame(height: 1)
            
            if items.count == 0 {
                EmptyListView(listName: "Purchased")
            } else {
                ItemListView(sections: sectionData(), sfSymbolName: "cart", identifiableAlertItem: $identifiableAlertItem, multiSectionDisplay: $multiSectionDisplay)
            }
            
            Divider()
        }
        .searchable(text: $searchText)

        .onAppear {
            handleOnAppear()
        }
        .onDisappear() {
            PersistentStore.shared.saveContext()
        }
        .navigationBarTitle("Purchased List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: addNewButton)
        }
        .alert(item: $identifiableAlertItem) { item in item.alert() }
        .sheet(item: $identifiableSheetItem) { item in item.content() }
        
    }
    
    func handleOnAppear() {
        searchText = ""
        today.update()
    }
    
    func addNewButton() -> some View {
        NavBarImageButton("plus") {
            identifiableSheetItem = AddNewItemSheetItem() { identifiableSheetItem = nil }
        }
    }
    
    func sectionData() -> [ItemsSectionData] {
        let searchQualifiedItems = items.filter({ searchText.appearsIn($0.name) })
        
        if !multiSectionDisplay {
            if searchText.isEmpty {
                return [ItemsSectionData(index: 1, title: "Items Purchased: \(items.count)", items: items.map({ $0 }))]
            }
            return [ItemsSectionData(index: 1, title: "Items Purchased containing: \"\(searchText)\": \(searchQualifiedItems.count)", items: searchQualifiedItems)]
        }
        
        let startingMarker = Calendar.current.date(byAdding: .day, value: -historyMarker, to: today.start)!
        let recentItems = searchQualifiedItems.filter({ $0.dateLastPurchased >= startingMarker })
        let allOlderItems = searchQualifiedItems.filter({ $0.dateLastPurchased < startingMarker })
        
        var section2Title = "Items Purchased Earlier: \(allOlderItems.count)"
        if !searchText.isEmpty {
            section2Title = "Items Purchased Earlier containing \"\(searchText)\": \(allOlderItems.count)"
        }
        
        return [
            ItemsSectionData(index: 1, title: section1Title(searchText: searchText, count: recentItems.count), items: recentItems),
            ItemsSectionData(index: 2, title: section2Title, items: allOlderItems)
        ]
    }
    
    func section1Title(searchText: String, count: Int) -> String {
        var title = "Items Purchased "
        if historyMarker == 0 {
            title += "Today "
        } else {
            title += "in the last \(historyMarker) days "
        }
        if !searchText.isEmpty {
            title += "containing \"\(searchText)\" "
        }
        title += "(\(count) items)"
        return title
    }
}
