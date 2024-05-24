//
//  ShoppingListApp.swift
//  ShoppingList
//
//  Created by fegrit.

import Foundation
import SwiftUI

/*
 Приложение будет содержать объект типа Today, который отслеживает "начало сегодняшнего дня".
 PurchasedItemsView необходимо знать, что означает "сегодня", чтобы правильно распределять
 свои данные, и может показаться, что PurchasedItemsView может справиться с этим самостоятельно.
 Однако, если вы свернете приложение в фоновый режим, когда отображается PurchasedItemsView,
 а затем вернете его через несколько дней, PurchasedItemsView покажет то же самое отображение,
 что и при сворачивании, и не будет знать об изменении; поэтому его представление нужно будет обновить.
 Вот почему это здесь: приложение, безусловно, знает, когда оно становится активным, и может обновить
 значение "сегодня", и PurchasedItemsView подхватит это изменение в своей среде.
 */
class Today: ObservableObject {
    @Published var start: Date = Calendar.current.startOfDay(for: Date())
    
    func update() {
        let newStart = Calendar.current.startOfDay(for: Date())
        if newStart != start {
            start = newStart
        }
    }
}

@main
struct ShoppingListApp: App {
    
    @StateObject var persistentStore = PersistentStore.shared
    @StateObject var today = Today()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistentStore.context)
                .environmentObject(today)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                                         perform: handleResignActive)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification),
                                         perform: handleBecomeActive)
        }
    }
    
    func handleResignActive(_ note: Notification) {
            // при переходе в фоновый режим сохраняем данные Core Data и останавливаем таймер
        persistentStore.saveContext()
        if kDisableTimerWhenAppIsNotActive {
            gInStoreTimer.suspend()
        }
    }
    
    func handleBecomeActive(_ note: Notification) {
            // когда приложение становится активным, перезапускаем таймер, если он был остановлен ранее.
            // также обновляем значение Today, так как мы можем переходить в активное состояние в другой день чем когда приложение было свернуто
        if gInStoreTimer.isSuspended {
            gInStoreTimer.start()
        }
        today.update()
    }

}
