
import SwiftUI

// это объединяет код того, что показывать, когда список пустой
struct EmptyListView: View {
	var listName: String
	var body: some View {
		VStack {
			Group {
				Text("There is empty yet")
                    .padding([.top], 200)
			}
			.font(.title)
			.foregroundColor(.secondary)
			Spacer()
		}
	}
}

