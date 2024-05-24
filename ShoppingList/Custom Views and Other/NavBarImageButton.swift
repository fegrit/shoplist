import SwiftUI

struct NavBarImageButton: View {
	private var systemName: String
	private var action: () -> Void
	
	init(_ systemImage: String, action: @escaping () -> Void) {
		self.systemName = systemImage
		self.action = action
	}
	
	var body: some View {
		Button {
			action()
		} label: {
			Image(systemName: systemName)
				.contentShape(Rectangle())
		}
	}
}
