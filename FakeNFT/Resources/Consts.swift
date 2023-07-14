import Foundation
import UIKit

struct Consts {
    struct Images {
        static let profile = UIImage(systemName: "person.crop.circle.fill")
        static let catalogue = UIImage(systemName: "rectangle.stack.fill")
        static let cart = Asset.Assets.cartIcon.image
        static let statistics = UIImage(systemName: "flag.2.crossed.fill")
        static let editBold = UIImage(systemName: "square.and.pencil",
                                      withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        static let chevron = UIImage(systemName: "chevron.right")
        static let cross = UIImage(systemName: "xmark")
        static let backButton = Asset.Assets.chevronBackward.image
        static let sortMenu = Asset.Assets.sortMenu.image
        static let like = Asset.Assets.like.image
    }
    
    struct Fonts {
        static let regular13 = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let regular15 = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let regular17 = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let medium10 = UIFont.systemFont(ofSize: 10, weight: .medium)
        static let bold17 = UIFont.systemFont(ofSize: 17, weight: .bold)
        static let bold22 = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let bold32 = UIFont.systemFont(ofSize: 32, weight: .bold)
        static let bold34 = UIFont.systemFont(ofSize: 34, weight: .bold)
    }
}
