import ActivityView
import MessageUI
import SwiftUI

// Этот код представляет представление списка покупок в приложении. Он отображает список элементов, которые нужно купить, и предоставляет функции для добавления, удаления и редактирования элементов списка.

// Кроме того, он содержит кнопки для выполнения различных операций со списком, таких как перемещение всех элементов из списка покупок или отметка всех элементов как доступных.

struct ShoppingListView: View {
		
	@FetchRequest(fetchRequest: Item.allItemsFR(onList: true))
	private var items: FetchedResults<Item>

	@State private var identifiableAlertItem: IdentifiableAlertItem?
	
	
	@State private var identifiableSheetItem: IdentifiableSheetItem?
	
	@State var multiSectionDisplay: Bool = false
		
	@State private var activityItem: ActivityItem?
	

	init() {
		print("ShoppingListView initialized")
	}
	
	var body: some View {
			VStack(spacing: 0) {
				
				Rectangle()
					.frame(height: 1)
            

				if items.count == 0 {
					EmptyListView(listName: "покупок")
				} else {
					ItemListView(sections: sectionData(),
											 sfSymbolName: "purchased",
											 identifiableAlertItem: $identifiableAlertItem,
											 multiSectionDisplay: $multiSectionDisplay)
				}

				if items.count > 0 {
					Divider()
					
					ShoppingListBottomButtons(itemsToBePurchased: items) {
						identifiableAlertItem = ConfirmMoveAllItemsOffShoppingListAlert()
					}
				} //end of if items.count > 0

				Divider()

			}
			.navigationBarTitle("Shopping List")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing, content: trailingButtons)
			}
		.alert(item: $identifiableAlertItem) { item in item.alert() }
		.sheet(item: $identifiableSheetItem) { item in item.content() }

		.onAppear {
			logAppear(title: "ShoppingListView")
		}
		.onDisappear {
			logDisappear(title: "ShoppingListView")
			PersistentStore.shared.saveContext()
		}
		
	}
	
	func sectionData() -> [ItemsSectionData] {
		
	
		if !multiSectionDisplay {

			let sortedItems = items
				.sorted(by: \.location.visitationOrder)
			return [ItemsSectionData(index: 1, title: "Оставшиеся товары: \(items.count)", items: sortedItems)
			]
		}
		

		let dictionaryByLocation = Dictionary(grouping: items, by: { $0.location })
			
		var completedSectionData = [ItemsSectionData]()
		var index = 1
		for key in dictionaryByLocation.keys.sorted() {
			completedSectionData.append(ItemsSectionData(index: index, title: key.name, items: dictionaryByLocation[key]!))
			index += 1
		}
		return completedSectionData
	}
	
	// MARK: - ToolbarItems
	
	func trailingButtons() -> some View {
		HStack(spacing: 12) {
			Button {

				activityItem = ActivityItem(items: shareContent())
			} label: {
				Image(systemName: "square.and.arrow.up")
			}

			.activitySheet($activityItem)
			.disabled(items.count == 0)

			NavBarImageButton("plus") {
				identifiableSheetItem = AddNewItemSheetItem() { identifiableSheetItem = nil }
			}
		}
	}
	
	func shareContent() -> String {
		
		var message = "Items in your bag: \n"
		
		let dictionary = Dictionary(grouping: items, by: { $0.location })
		for key in dictionary.keys.sorted() {
			let items = dictionary[key]!
			message += "\n\(key.name), \(items.count) item(s)\n\n"
			for item in items {
				message += "  \(item.name)\n"
			}
		}
		
		return message
	}

}


struct ShoppingListBottomButtons: View {
	

	var itemsToBePurchased: FetchedResults<Item>

	var moveAllItemsOffShoppingList: () -> ()

	var showMarkAllAvailable: Bool { !itemsToBePurchased.allSatisfy({ $0.isAvailable }) }
	
	var body: some View {
		
		HStack {
			Spacer()
			
			Button {
				moveAllItemsOffShoppingList()
			} label: {
				Text("Delete all")
			}
			
			if showMarkAllAvailable {
				Spacer()
				
				Button {
					itemsToBePurchased.forEach { $0.markAvailable() }
				} label: {
					Text("Mark all available")
				}
			}
			
			Spacer()
		}
		.padding(.vertical, 6)
		.animation(.easeInOut(duration: 0.4), value: showMarkAllAvailable)

	}
	
}
