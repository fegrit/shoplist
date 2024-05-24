import Foundation
import CoreData

final class PersistentStore: ObservableObject {
	
	private(set) static var shared = PersistentStore()
	
	// this makes sure we're the only one who can create one of these
	private init() { }
		
	lazy var persistentContainer: NSPersistentContainer = {
		
#if targetEnvironment(simulator)
		
		let container = NSPersistentContainer(name: "ShoppingList")
#else
		
		let container = NSPersistentContainer(name: "ShoppingList")

#endif

		guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
			fatalError("\(#function): Failed to retrieve a persistent store description.")
		}
		persistentStoreDescriptions.setOption(true as NSNumber,
																					forKey: NSPersistentHistoryTrackingKey)
		persistentStoreDescriptions.setOption(true as NSNumber,
																					forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
		
	
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
            
				fatalError("Unresolved loadPersistentStores error \(error), \(error.userInfo)")
			}
			
		})
		
		// (2) also suggested for cloud-based Core Data are the two lines below for syncing with
		// the cloud.  i don't think there's any harm in adding these even for a single, on-disk
		// local store.
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		
		return container
	}()
	
	var context: NSManagedObjectContext { persistentContainer.viewContext }
	
	func saveContext () {
		if context.hasChanges {
			do {
				try context.save()
			} catch let error as NSError {
				NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
			}
		}
	}
}
