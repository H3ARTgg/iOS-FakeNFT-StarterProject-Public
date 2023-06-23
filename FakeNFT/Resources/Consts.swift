import Foundation
import UIKit

struct Consts {
    struct LocalizedStrings {
        static let profile = NSLocalizedString("profile.icon", comment: "Profile tabbar icon title")
        static let catalogue = NSLocalizedString("catalogue.icon", comment: "Catalogue tabbar icon title")
        static let cart = NSLocalizedString("cart.icon", comment: "Cart tabbar icon title")
        static let statistics = NSLocalizedString("statistics.icon", comment: "Statistics tabbar icon title")
        // Catalogue
        static let failImageLoadText = NSLocalizedString("image.load.failure", value: "Попробовать снова", comment: "Catalogue fail button text")
        static let sortingCatalogueMessage = NSLocalizedString("sort.catalogue", value: "Сортировка", comment: "Catalogue sort message")
        static let byName = NSLocalizedString("by.name", value: "По названию", comment: "Sorting by name")
        static let byNftCount = NSLocalizedString("by.nft.count", value: "По количеству NFT", comment: "Sorting by nft count in collection")
        static let close = NSLocalizedString("close", value: "Закрыть", comment: "Close event")
    }
    
    struct Images {
        static let profile = UIImage(systemName: "person.crop.circle.fill")
        static let catalogue = UIImage(systemName: "rectangle.stack.fill")
        static let cart = Asset.Assets.cartIcon.image
        static let statistics = UIImage(systemName: "flag.2.crossed.fill")
        static let sortButtonCatalogue = Asset.Assets.sortButtonCatalogue.image
    }
    
    struct Fonts {
        static let regular13 = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let regular15 = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let regular17 = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let medium10 = UIFont.systemFont(ofSize: 10, weight: .medium)
        static let bold17 = UIFont.systemFont(ofSize: 10, weight: .bold)
        static let bold22 = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let bold32 = UIFont.systemFont(ofSize: 32, weight: .bold)
        static let bold34 = UIFont.systemFont(ofSize: 34, weight: .bold)
    }
}
