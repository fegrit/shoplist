
import SwiftUI

struct SLCenteredButton: View {
	let title: String
	let action: () -> Void
	
	var body: some View {
		HStack {
			Spacer()
			Button(title) {
				action()
			}
			Spacer()
		}
	}
}

