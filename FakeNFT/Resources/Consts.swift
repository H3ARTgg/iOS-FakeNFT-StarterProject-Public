import Foundation
import UIKit

struct Consts {
    struct LocalizedStrings {
        static let profile = NSLocalizedString("profile.icon", comment: "Profile tabbar icon title")
        static let catalogue = NSLocalizedString("tatistic.FilterAlert.ActionSheep.SortByName.Title", comment: "Catalogue tabbar icon title")
        static let cart = NSLocalizedString("cart.icon", comment: "Cart tabbar icon title")
    }
    
    struct Images {
        static let profile = UIImage(systemName: "person.crop.circle.fill")
        static let catalogue = UIImage(systemName: "rectangle.stack.fill")
        static let cart = Asset.Assets.cartIcon.image
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
    
    struct Statistic {
        static let topConstant: CGFloat = 20
        static let sideConstant: CGFloat = 16
        static let heightUserTableViewCell: CGFloat = 88
        static let minimumSpacingForSectionAt: CGFloat = 5
        static let ratingTableViewAccessibilityIdentifier = "Image list"
        static let userSiteButtonAccessibilityIdentifier = "User site"
        static let collectionButtonAccessibilityIdentifier = "User collection"
        static let filterButtonAccessibilityIdentifier = "Filter button"
        static let webViewAccessibilityIdentifier = "NftWebView"
        
        // UserCardViewController
        static let userCollectionButtonHeight: CGFloat = 54
        static let userSiteButtonHeight: CGFloat = 40
        static let avatarWidth: CGFloat = 70
        static let stackViewTopAnchorConstant: CGFloat = 10
        
        // Network
        static let urlStatistic: URL? = URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/users")
        static let urlNft: URL? = URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/nft/")
    }
}
