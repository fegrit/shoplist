import Foundation
import SwiftUI

struct SectionHeader: ViewModifier {
	func body(content: Content) -> some View {
		content
			.textCase(.none)
	}
}

extension View {
	func sectionHeader() -> some View {
		modifier(SectionHeader())
	}
}

