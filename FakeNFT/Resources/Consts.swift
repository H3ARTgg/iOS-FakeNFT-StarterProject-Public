import Foundation
import UIKit

struct Consts {
    struct LocalizedStrings {
        static let profile = NSLocalizedString("profile.icon", comment: "Profile tabbar icon title")
        static let catalogue = NSLocalizedString("catalogue.icon", comment: "Catalogue tabbar icon title")
        static let cart = NSLocalizedString("cart.icon", comment: "Cart tabbar icon title")
        static let statistics = NSLocalizedString("statistics.icon", comment: "Statistics tabbar icon title")
        
        static let statisticAlertTitle = NSLocalizedString("statisticAlert.title", comment: "text for statistic's title alert")
        static let statisticActionSheepName = NSLocalizedString("statisticActionSheep.sortByName", comment: "text for statistic's action sheep sort by name")
        static let statisticActionSheepRating = NSLocalizedString("statisticActionSheep.sortByRating", comment: "text for statistic's action sheep sort by rating")
        static let alertCancelText = NSLocalizedString("cancelActionText", comment: "Text for alert cancel button")
        static let userSiteButtonTitle = NSLocalizedString("userSiteButtonTitle", comment: "Text for userSiteButton")
        static let userCollectionButtonTitle = NSLocalizedString("userCollectionButtonTitle", comment: "Text for userCollectionButtonTitle")
    }
    
    struct Images {
        static let profile = UIImage(systemName: "person.crop.circle.fill")
        static let catalogue = UIImage(systemName: "rectangle.stack.fill")
        static let cart = Asset.Assets.cartIcon.image
        static let statistics = UIImage(systemName: "flag.2.crossed.fill")
        
        static let sortIcon = Asset.Assets.sortIcon.image
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
        
        // Network
        static let urlStatistic: URL? = URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/users")
        static let limiteUsersOnPage = 10
    }
    
    struct UserCard {
        
    }
}
