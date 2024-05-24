import Foundation
import CoreData

// Расширение для класса NSManagedObject, предоставляющее удобные методы для работы с данными CoreData.
// Включает функции для подсчёта объектов, получения всех объектов и поиска объекта по UUID в заданном контексте.

extension NSManagedObject {
	
	class func count(context: NSManagedObjectContext) -> Int {
		let fetchRequest: NSFetchRequest<Self> = NSFetchRequest<Self>(entityName: Self.description())
		do {
			let result = try context.count(for: fetchRequest)
			return result
		} catch let error as NSError {
			NSLog("Ошибка подсчета NSManagedObjects \(Self.description()): \(error.localizedDescription), \(error.userInfo)")
		}
		return 0
	}
	
	class func allObjects(context: NSManagedObjectContext) -> [NSManagedObject] {
		let fetchRequest: NSFetchRequest<Self> = NSFetchRequest<Self>(entityName: Self.description())
		do {
			let result = try context.fetch(fetchRequest)
			return result
		} catch let error as NSError {
			NSLog("Ошибка при выборке NSManagedObjects \(Self.description()): \(error.localizedDescription), \(error.userInfo)")
		}
		return []
	}

	class func object(id: UUID, context: NSManagedObjectContext) -> Self? {
		let fetchRequest: NSFetchRequest<Self> = NSFetchRequest<Self>(entityName: Self.description())
		fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
		do {
			let results = try context.fetch(fetchRequest)
			return results.first
		} catch let error as NSError {
			NSLog("Ошибка при выборке NSManagedObjects \(Self.description()): \(error.localizedDescription), \(error.userInfo)")
		}
		return nil
	}

	
}
