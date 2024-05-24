import Foundation
import SwiftUI

// Этот код отвечает за отображение списка покупок в приложении. Он позволяет пользователю просматривать список покупок, а также изменять статус покупки (добавлять/удалять элементы из списка покупок) и доступность товара (например, отмечать товары как доступные или недоступные для покупки).

// Также код обрабатывает действия пользователя, такие как нажатие на элемент списка или контекстное меню для выполнения различных операций, таких как перемещение товара между списками или удаление товара.

struct ItemListView: View {

    var sections: [ItemsSectionData]
    var sfSymbolName: String
    @Binding var identifiableAlertItem: IdentifiableAlertItem?
    @Binding var multiSectionDisplay: Bool
    @State private var itemsChecked = [Item]()

    var body: some View {
        List {
            ForEach(sections) { section in
                Section(header: sectionHeader(section: section)) {
                    ForEach(section.items) { item in
                        NavigationLink {
                            ModifyExistingItemView(item: item)
                        } label: {
                            SelectableItemRowView(item: item,
                                                                        selected: itemsChecked.contains(item),
                                                                        sfSymbolName: sfSymbolName) { handleItemTapped(item) }
                        }
                        .contextMenu {
                            ItemContextMenu(item: item) {
                                identifiableAlertItem = ConfirmDeleteItemAlert(item: item)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .animation(.default, value: sections)
    }

    @ViewBuilder
    func sectionHeader(section: ItemsSectionData) -> some View {
        HStack {
            Text(section.title).textCase(.none)

            if section.index == 1 {
                Spacer()

                SectionHeaderButton(selected: multiSectionDisplay == false, systemName: "tray") {
                    multiSectionDisplay = false
                }

                Rectangle()
                    .frame(width: 1, height: 20)

                SectionHeaderButton(selected: multiSectionDisplay == true, systemName: "tray.2") {
                    multiSectionDisplay = true
                }
            }
        }
    }

    func handleItemTapped(_ item: Item) {
        if !itemsChecked.contains(item) {
            itemsChecked.append(item)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                withAnimation {
                    item.toggleOnListStatus()
                    itemsChecked.removeAll(where: { $0 == item })
                }
            }
        }
    }
}

struct ItemContextMenu: View {

    var item: Item
    var affirmDeletion: () -> Void

    var body: some View {
        Button(action: { item.toggleOnListStatus() }) {
            Text(item.onList ? "Move to Purchased" : "Move to ShoppingList")
            Image(systemName: item.onList ? "purchased" : "cart")
        }

        Button(action: { item.toggleAvailableStatus() }) {
            Text(item.isAvailable ? "Mark as Unavailable" : "Mark as Available")
            Image(systemName: item.isAvailable ? "pencil.slash" : "pencil")
        }

        Button(action: { affirmDeletion() }) {
            Text("Delete This Item")
            Image(systemName: "trash")
        }
    }
}
