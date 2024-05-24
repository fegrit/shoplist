import SwiftUI

// Отображает отдельную строку для каждого местоположения в списке покупок. Каждая строка содержит информацию о местоположении, такую как его название, количество элементов в этом местоположении, и порядковый номер посещения.
// Каждое местоположение представлено цветной полоской слева, которая помогает визуально различать места друг от друга.

struct LocationRowData {
    let name: String
    let itemCount: Int
    let visitationOrder: Int
    let uiColor: UIColor
    
    init(location: Location) {
        name = location.name
        itemCount = location.itemCount
        visitationOrder = location.visitationOrder
        uiColor = location.uiColor
    }
}

struct LocationRowView: View {
     var rowData: LocationRowData

    var body: some View {
        HStack {
            Color(rowData.uiColor)
                .frame(width: 10, height: 36)
            
            VStack(alignment: .leading) {
                Text(rowData.name)
                    .font(.headline)
                Text(subtitle())
                    .font(.caption)
            }
            if rowData.visitationOrder != kUnknownLocationVisitationOrder {
                Spacer()
                Text(String(rowData.visitationOrder))
            }
        }
    }
    
    func subtitle() -> String {
        if rowData.itemCount == 1 {
            return "1 item"
        } else {
            return "\(rowData.itemCount) items"
        }
    }
}
