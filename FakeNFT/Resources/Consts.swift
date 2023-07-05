import Foundation
import UIKit

struct Consts {
    struct LocalizedStrings {
        static let profile = NSLocalizedString("profile.icon", comment: "Profile tabbar icon title")
        static let catalogue = NSLocalizedString("catalogue.icon", comment: "Catalogue tabbar icon title")
        static let cart = NSLocalizedString("cart.icon", comment: "Cart tabbar icon title")
        static let statistics = NSLocalizedString("statistics.icon", comment: "Statistics tabbar icon title")
        static let ownedNfts = NSLocalizedString("profile.owned", value: "Мои NFT", comment: "Personal owned NFTs")
        static let favoriteNfts = NSLocalizedString("profile.favorite", value: "Избранные NFT", comment: "Personal favorite NFTs")
        static let aboutDeveloper = NSLocalizedString("profile.developer", value: "О разработчике", comment: "About developer")
        static let changePhoto = NSLocalizedString("profileEdit.changePhoto", value: "Сменить фото", comment: "Change photo")
        static let profileSortAlertTitle = NSLocalizedString("profile.sort", value: "Сортировка", comment: "Text for sort action sheet title")
        static let profileSortAlertByPriceText = NSLocalizedString("profile.byPrice", value: "По цене", comment: "Text for sort action sheet price button")
        static let profileSortAlertByRatingText = NSLocalizedString("profile.byRating", value: "По рейтингу", comment: "Text for sort action sheet rating button")
        static let profileSortAlertByNameText = NSLocalizedString("profile.byTitle", value: "По названию", comment: "Text for sort action sheet title button")
        static let profileSortAlertCloseText = NSLocalizedString("profile.close", value: "Закрыть", comment: "Text for sort action sheet close button")
        static let profileYouHaveNotAnyNfts = NSLocalizedString("profile.noNfts", value: "У Вас еще нет NFT", comment: "Text for no nfts")
    }
    
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
