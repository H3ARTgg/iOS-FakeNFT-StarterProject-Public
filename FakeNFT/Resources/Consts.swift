import Foundation
import UIKit

struct Consts {
    struct LocalizedStrings {
        static let profile = NSLocalizedString("profile.icon", comment: "Profile tabbar icon title")
        static let catalogue = NSLocalizedString("catalogue.icon", comment: "Catalogue tabbar icon title")
        static let cart = NSLocalizedString("cart.icon", comment: "Cart tabbar icon title")
        static let statistics = NSLocalizedString("statistics.icon", comment: "Statistics tabbar icon title")
        
        // Cart
        static let cartButtonToPay = NSLocalizedString("button.to.pay", value: "К оплате", comment: "Button for go to the payment screen")
        static let cartLabelAmountNft = NSLocalizedString("label.amount.nft", value: "NFT", comment: "Label for amount nfts")
        static let cartLabelEth = NSLocalizedString("label.currency.eth", value: "ETH", comment: "Label for currency")
        static let cartDeleteMessage = NSLocalizedString("label.delete.nft", value: "Вы уверены, что хотите удалить объект из корзины?", comment: "Message for user when deleting nft")
        static let cartDeleteButton = NSLocalizedString("button.delete.nft", value: "Удалить", comment: "Delete nft")
        static let cartCancelButton = NSLocalizedString("label.cancel", value: "Вернуться", comment: "cancel deletion of nft")
        static let cartAlertTitle = NSLocalizedString("alert.sort", value: "Сортировка", comment: "title alert controller")
        static let cartSortFromPrice = NSLocalizedString("sort.price", value: "По цене", comment: "sort nfts rom price")
        static let cartSortFromRating = NSLocalizedString("sort.rating", value: "По рейтингу", comment: "sort nfts from rating")
        static let cartSortFromTitle = NSLocalizedString("sort.title", value: "По названию", comment: "sort nfts from title")
        static let cartCloseAlert = NSLocalizedString("alert.close", value: "Закрыть", comment: "action for close alert")
    }
    
    struct Images {
        static let profile = UIImage(systemName: "person.crop.circle.fill")
        static let catalogue = UIImage(systemName: "rectangle.stack.fill")
        static let cart = Asset.Assets.cartIcon.image
        static let statistics = UIImage(systemName: "flag.2.crossed.fill")
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
    
    struct Cart {
        struct ProductRating {
            static let widthProductRating: CGFloat = 68
        }
        
        struct MessageStackView {
            static let widthMessageStackView: CGFloat = 180
        }
                
        struct ProductImageView {
            static let heightProductImageView: CGFloat = 108
            static let imageProductRadius: CGFloat = 12
        }
        
        struct PaymentView {
            static let paymentViewRadius: CGFloat = 12
        }
        
        struct CellIdentifier {
            static let productCartCellIdentifier = "cartCell"
        }
        
        struct Url {
            static let baseURL = "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/"
        }
        
        static let heightButton: CGFloat = 44
        static let buttonRadius: CGFloat = 16
    }
}
