import Foundation

extension Sequence {

	func count(where selector: (Element) -> Bool) -> Int {
		reduce(0) { (sum, Element) -> Int in
			return selector(Element) ? sum + 1 : sum
		}
	}

	func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
		return map { $0[keyPath: keyPath] }
	}
	
	func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
		return sorted { a, b in
			return a[keyPath: keyPath] < b[keyPath: keyPath]
		}
	}
}
