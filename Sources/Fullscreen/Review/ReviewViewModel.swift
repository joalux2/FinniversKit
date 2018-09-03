//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ReviewViewModel {
    var title: String { get }
    var subtitle: String { get }
    var profiles: [ReviewViewProfileModel] { get }
    var skiptitle: String { get }
    var nonOfTheseTitle: String { get }
}

public protocol ReviewViewProfileModel {
    var name: String { get }
    var image: URL? { get }
}
