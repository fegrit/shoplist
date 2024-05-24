import Foundation

struct ItemsSectionData: Identifiable, Hashable {
    var id: Int { hashValue }
    let index: Int
    let title: String
    let items: [Item]
}
