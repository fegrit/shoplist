import Foundation
import SwiftUI

// Этот код создает специальное окно, чтобы показать ваши покупки. Каждая покупка имеет свою маленькую иконку и цветную полоску. Вы можете выбрать покупку, нажав на иконку, и увидеть ее детали, такие как название и место покупки.

struct SelectableItemRowView: View {
    
    @ObservedObject var item: Item
    var selected: Bool
    var sfSymbolName: String
    var handleTap: () -> ()
    
    var body: some View {
        HStack {
            ZStack {
                if selected {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                Image(systemName: "circle")
                    .foregroundColor(Color(item.uiColor))
                    .font(.title)
                if selected {
                    Image(systemName: sfSymbolName)
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
            }
            .animation(.easeInOut, value: selected)
            .frame(width: 24, height: 24)
            .onTapGesture(perform: handleTap)
            
            Color(item.uiColor)
                .frame(width: 10, height: 36)
            
            VStack(alignment: .leading) {
                if item.isAvailable {
                    Text(item.name)
                } else {
                    Text(item.name)
                        .italic()
                        .strikethrough()
                }
                Text(item.locationName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(item.quantity)")
                .font(.headline)
                .foregroundColor(Color.blue)
        }
    }
}
