import SwiftUI

// MainView - это точка входа в приложение. Это табличное представление с пятью вкладками.

struct MainView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationView { ShoppingListView() }
                .tabItem { Label("Shopping List", systemImage: "cart") }
                .tag(1)
            
            NavigationView { PurchasedItemsView() }
                .tabItem { Label("Purchased", systemImage: "purchased") }
                .tag(2)
            
            NavigationView { LocationsView() }
                .tabItem { Label("Locations", systemImage: "map") }
                .tag(3)
            
            NavigationView { TimerTabView()  }
                .tabItem { Label("Timer", systemImage: "stopwatch") }
                .tag(4)
            
            NavigationView { PreferencesTabView() }
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(5)
            
        } // конец TabView
        .navigationViewStyle(.stack)

    } // конец var body: some View
    
}
