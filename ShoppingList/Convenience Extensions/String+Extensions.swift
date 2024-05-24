import Foundation

extension String {
	
	func appearsIn(_ str: String) -> Bool {
		let cleanedSearchText = self.trimmingCharacters(in: .whitespacesAndNewlines)
		if cleanedSearchText.isEmpty {
			return true
		}
		return str.localizedCaseInsensitiveContains(cleanedSearchText)
	}
}
