// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Plural format key: "%#@nfts@"
  internal static func profileNfts(_ p1: Int) -> String {
    return L10n.tr("Localizable", "profileNfts", p1, fallback: "Plural format key: \"%#@nfts@\"")
  }
  internal enum Statistic {
    internal enum AlertAction {
      internal enum Cancel {
        /// Cancel
        internal static let title = L10n.tr("Localizable", "Statistic.AlertAction.Cancel.Title", fallback: "Cancel")
      }
      internal enum Repeat {
        /// Repeat
        internal static let title = L10n.tr("Localizable", "Statistic.AlertAction.Repeat.Title", fallback: "Repeat")
      }
      internal enum SortByName {
        /// By name
        internal static let title = L10n.tr("Localizable", "Statistic.AlertAction.SortByName.Title", fallback: "By name")
      }
      internal enum SortByRating {
        /// By rating
        internal static let title = L10n.tr("Localizable", "Statistic.AlertAction.SortByRating.Title", fallback: "By rating")
      }
    }
    internal enum ErrorAlert {
      /// Error
      internal static let title = L10n.tr("Localizable", "Statistic.ErrorAlert.Title", fallback: "Error")
    }
    internal enum ErrorPlugView {
      /// Oops, something went wrong(
      internal static let text = L10n.tr("Localizable", "Statistic.ErrorPlugView.Text", fallback: "Oops, something went wrong(")
    }
    internal enum FilterAlert {
      /// Sorting
      internal static let title = L10n.tr("Localizable", "Statistic.FilterAlert.Title", fallback: "Sorting")
    }
    internal enum PlugLabel {
      /// No NFT
      internal static let text = L10n.tr("Localizable", "Statistic.PlugLabel.Text", fallback: "No NFT")
    }
    internal enum UserCollectionButton {
      /// Collection NFT (%d)
      internal static func title(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Statistic.UserCollectionButton.Title", p1, fallback: "Collection NFT (%d)")
      }
    }
    internal enum UserCollectionViewController {
      /// Collection NFT
      internal static let title = L10n.tr("Localizable", "Statistic.UserCollectionViewController.Title", fallback: "Collection NFT")
    }
    internal enum UserSiteButton {
      /// Go to site
      internal static let title = L10n.tr("Localizable", "Statistic.UserSiteButton.Title", fallback: "Go to site")
    }
  }
  internal enum Alert {
    /// Close
    internal static let close = L10n.tr("Localizable", "alert.close", fallback: "Close")
    /// Sorting
    internal static let sort = L10n.tr("Localizable", "alert.sort", fallback: "Sorting")
  }
  internal enum Button {
    internal enum Delete {
      /// Delete
      internal static let nft = L10n.tr("Localizable", "button.delete.nft", fallback: "Delete")
    }
    internal enum To {
      /// To pay
      internal static let pay = L10n.tr("Localizable", "button.to.pay", fallback: "To pay")
    }
  }
  internal enum By {
    /// By title
    internal static let name = L10n.tr("Localizable", "by.name", fallback: "By title")
    internal enum Nft {
      /// By number of NFTs
      internal static let count = L10n.tr("Localizable", "by.nft.count", fallback: "By number of NFTs")
    }
  }
  internal enum Cart {
    /// Cart is empty
    internal static let cartIsEmpty = L10n.tr("Localizable", "cart.cartIsEmpty", fallback: "Cart is empty")
    /// Cart
    internal static let icon = L10n.tr("Localizable", "cart.icon", fallback: "Cart")
    internal enum Alert {
      internal enum Payment {
        /// OK
        internal static let action = L10n.tr("Localizable", "cart.alert.payment.action", fallback: "OK")
        /// Choose a currency
        internal static let message = L10n.tr("Localizable", "cart.alert.payment.message", fallback: "Choose a currency")
        /// Error
        internal static let title = L10n.tr("Localizable", "cart.alert.payment.title", fallback: "Error")
      }
    }
    internal enum Button {
      /// Pay
      internal static let payment = L10n.tr("Localizable", "cart.button.payment", fallback: "Pay")
      /// User Agreement
      internal static let terms = L10n.tr("Localizable", "cart.button.terms", fallback: "User Agreement")
    }
    internal enum Label {
      /// By making a purchase, you agree to the terms
      internal static let terms = L10n.tr("Localizable", "cart.label.terms", fallback: "By making a purchase, you agree to the terms")
    }
    internal enum Payment {
      /// Select a Payment Method
      internal static let method = L10n.tr("Localizable", "cart.payment.method", fallback: "Select a Payment Method")
    }
    internal enum ResultPayment {
      /// To try one more time
      internal static let failureButton = L10n.tr("Localizable", "cart.resultPayment.failureButton", fallback: "To try one more time")
      /// Oops! Something went wrong :(
      internal static let failureTitle = L10n.tr("Localizable", "cart.resultPayment.failureTitle", fallback: "Oops! Something went wrong :(")
      /// Try again!
      internal static let failureTryTitle = L10n.tr("Localizable", "cart.resultPayment.failureTryTitle", fallback: "Try again!")
      /// Back to catalog
      internal static let successButton = L10n.tr("Localizable", "cart.resultPayment.successButton", fallback: "Back to catalog")
      /// congratulations on your purchase!
      internal static let successCongratulationTitle = L10n.tr("Localizable", "cart.resultPayment.successCongratulationTitle", fallback: "congratulations on your purchase!")
      /// Success! Payment went through
      internal static let successTitle = L10n.tr("Localizable", "cart.resultPayment.successTitle", fallback: "Success! Payment went through")
    }
  }
  internal enum Catalogue {
    /// Catalogue
    internal static let icon = L10n.tr("Localizable", "catalogue.icon", fallback: "Catalogue")
  }
  internal enum Collection {
    /// Collection author
    internal static let author = L10n.tr("Localizable", "collection.author", fallback: "Collection author")
  }
  internal enum Error {
    internal enum Connection {
      /// Something went wrong(
      internal static let message = L10n.tr("Localizable", "error.connection.message", fallback: "Something went wrong(")
    }
  }
  internal enum Image {
    internal enum Load {
      /// Try again
      internal static let failure = L10n.tr("Localizable", "image.load.failure", fallback: "Try again")
    }
  }
  internal enum Label {
    /// Return
    internal static let cancel = L10n.tr("Localizable", "label.cancel", fallback: "Return")
    internal enum Amount {
      /// NFT
      internal static let nft = L10n.tr("Localizable", "label.amount.nft", fallback: "NFT")
    }
    internal enum Currency {
      /// ETH
      internal static let eth = L10n.tr("Localizable", "label.currency.eth", fallback: "ETH")
    }
    internal enum Delete {
      /// Do you want to remove an item?
      internal static let nft = L10n.tr("Localizable", "label.delete.nft", fallback: "Do you want to remove an item?")
    }
  }
  internal enum Profile {
    /// Description
    internal static let about = L10n.tr("Localizable", "profile.about", fallback: "Description")
    /// By price
    internal static let byPrice = L10n.tr("Localizable", "profile.byPrice", fallback: "By price")
    /// By rating
    internal static let byRating = L10n.tr("Localizable", "profile.byRating", fallback: "By rating")
    /// By title
    internal static let byTitle = L10n.tr("Localizable", "profile.byTitle", fallback: "By title")
    /// Change photo
    internal static let changePhoto = L10n.tr("Localizable", "profile.changePhoto", fallback: "Change photo")
    /// Close
    internal static let close = L10n.tr("Localizable", "profile.close", fallback: "Close")
    /// About developer
    internal static let developer = L10n.tr("Localizable", "profile.developer", fallback: "About developer")
    /// Favorite
    internal static let favorite = L10n.tr("Localizable", "profile.favorite", fallback: "Favorite")
    /// Favorite NFTs
    internal static let favoriteScreen = L10n.tr("Localizable", "profile.favoriteScreen", fallback: "Favorite NFTs")
    /// from
    internal static let from = L10n.tr("Localizable", "profile.from", fallback: "from")
    /// Profile
    internal static let icon = L10n.tr("Localizable", "profile.icon", fallback: "Profile")
    /// Name
    internal static let name = L10n.tr("Localizable", "profile.name", fallback: "Name")
    /// You don't have any favorite NFTs yet
    internal static let noFavoriteNfts = L10n.tr("Localizable", "profile.noFavoriteNfts", fallback: "You don't have any favorite NFTs yet")
    /// You don't have NFTs yet
    internal static let noNfts = L10n.tr("Localizable", "profile.noNfts", fallback: "You don't have NFTs yet")
    /// My
    internal static let owned = L10n.tr("Localizable", "profile.owned", fallback: "My")
    /// My NFTs
    internal static let ownedScreen = L10n.tr("Localizable", "profile.ownedScreen", fallback: "My NFTs")
    /// Price
    internal static let price = L10n.tr("Localizable", "profile.price", fallback: "Price")
    /// Website
    internal static let site = L10n.tr("Localizable", "profile.site", fallback: "Website")
    /// Sorting
    internal static let sort = L10n.tr("Localizable", "profile.sort", fallback: "Sorting")
  }
  internal enum Router {
    /// Back
    internal static let back = L10n.tr("Localizable", "router.back", fallback: "Back")
    /// Error
    internal static let error = L10n.tr("Localizable", "router.error", fallback: "Error")
  }
  internal enum Sort {
    /// Sorting
    internal static let catalogue = L10n.tr("Localizable", "sort.catalogue", fallback: "Sorting")
    /// By price
    internal static let price = L10n.tr("Localizable", "sort.price", fallback: "By price")
    /// By rating
    internal static let rating = L10n.tr("Localizable", "sort.rating", fallback: "By rating")
    /// By title
    internal static let title = L10n.tr("Localizable", "sort.title", fallback: "By title")
  }
  internal enum Statistics {
    /// Statistics
    internal static let icon = L10n.tr("Localizable", "statistics.icon", fallback: "Statistics")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
