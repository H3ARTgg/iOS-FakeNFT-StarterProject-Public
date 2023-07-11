import Foundation
import UIKit

struct Consts {
    struct LocalizedStrings {
        static let profile = NSLocalizedString("profile.icon", comment: "Profile tabbar icon title")
        static let catalogue = NSLocalizedString("catalogue.icon", comment: "Catalogue tabbar icon title")
        static let cart = NSLocalizedString("cart.icon", comment: "Cart tabbar icon title")
        static let statistics = NSLocalizedString("statistics.icon", comment: "Statistics tabbar icon title")
        
        // Statistic epic
        static let statisticAlertTitle = NSLocalizedString("statisticAlert.title", value: "Sorting", comment: "text for statistic's title alert")
        static let statisticActionSheepName = NSLocalizedString("statisticActionSheep.sortByName", value: "By name", comment: "text for statistic's title alert")
        static let statisticActionSheepRating = NSLocalizedString("statisticActionSheep.sortByRating", value: "By rating", comment: "text for statistic's action sheep sort by rating")
        static let alertCancelText = NSLocalizedString("cancelAction.Text", value: "Cancel", comment: "Text for alert cancel button")
        static let userSiteButtonTitle = NSLocalizedString("userSiteButton.Title", value: "Go to site", comment: "Text for userSiteButton")
        static let userCollectionButtonTitle = NSLocalizedString("userCollectionButton.title", value: "Collection NFT (%d)", comment: "Text for userCollectionButtonTitle")
        static let userCollectionViewControllerTitle = NSLocalizedString("userCollectionViewController.Title", value: "Collection NFT", comment: "Title for UserCollectionViewController")
        static let plugLabelText = NSLocalizedString("plugLabel.Text", value: "No NFT", comment: "text for plug label in UserCollectionViewController")
        
        static let statisticErrorAlertTitle = NSLocalizedString("statisticErrorAlert.title", value: "Error", comment: "text for statistic's error title alert")
        static let statisticErrorActionSheepNameRepeat = NSLocalizedString("statisticErrorActionSheep.repeat", value: "Repeat", comment: "text for statistic's error title alert repeat")
        
        static let statisticErrorPlugView = NSLocalizedString("statisticErrorPlugView.text", value: "Oops, something went wrong(", comment: "text for statistic's error title alert repeat")
    }
    
    struct Images {
        static let profile = UIImage(systemName: "person.crop.circle.fill")
        static let catalogue = UIImage(systemName: "rectangle.stack.fill")
        static let cart = Asset.Assets.cartIcon.image
        static let statistics = UIImage(systemName: "flag.2.crossed.fill")
        
        static let sortIcon = Asset.Assets.sortIcon.image
        static let backButton = Asset.Assets.chevronBackward.image
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
