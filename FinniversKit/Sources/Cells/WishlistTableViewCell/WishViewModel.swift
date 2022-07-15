import Foundation

public struct WishViewModel: Codable, Swift.Identifiable, Equatable {
    public static func == (lhs: WishViewModel, rhs: WishViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id: String
    var imageUrl: String?
    var price: String?
    var ribbonViewModel: RibbonViewModel?
    var updateTime: Date?
    var place: String? // location from AdViewData.Location for testing purpose
    var title: String?
    
    public init(id: String,
                imageUrl: String?,
                price: String?,
                ribbonViewModel: RibbonViewModel?,
                updateTime: Date?,
                place: String?,
                title: String?) {
        self.id = id
        self.imageUrl = imageUrl
        self.price = price
        self.ribbonViewModel = ribbonViewModel
        self.updateTime = updateTime
        self.place = place
        self.title = title
    }
}
