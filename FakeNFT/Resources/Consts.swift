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
            static let currencyCartViewCell = "cartCurrency"
        }

        struct Url {
            static let baseUrl = "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/"
            static let termsUrl = "https://yandex.ru/legal/practicum_termsofuse/"
        }

        static let heightButton: CGFloat = 44
        static let buttonRadius: CGFloat = 16
    }
}
