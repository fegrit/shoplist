import SwiftUI

struct SectionHeaderButton: View {
	
	var selected: Bool
	var systemName: String
	var action: () -> Void
	
	var body: some View {
		RoundedRectangle(cornerRadius: 8)
			.fill(selected ? Color(.systemGray4) : Color.clear)
			.frame(width: 30, height: 30)
			.overlay(
				Button(action: action) {
					Image(systemName: systemName)
						.font(.body)
				})
			.contentShape(Rectangle())
	}
}
