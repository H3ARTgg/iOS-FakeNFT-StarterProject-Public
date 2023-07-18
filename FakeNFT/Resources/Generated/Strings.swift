// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Close
  internal static let close = L10n.tr("Localizable", "close", fallback: "Close")
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
  internal enum CancelAction {
    /// Cancel
    internal static let text = L10n.tr("Localizable", "cancelAction.Text", fallback: "Cancel")
  }
  internal enum Cart {
    /// Cart
    internal static let icon = L10n.tr("Localizable", "cart.icon", fallback: "Cart")
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
    internal enum Try {
      /// Try again
      internal static let again = L10n.tr("Localizable", "error.try.again", fallback: "Try again")
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
      /// Are you sure you want to remove the item from the trash?
      internal static let nft = L10n.tr("Localizable", "label.delete.nft", fallback: "Are you sure you want to remove the item from the trash?")
    }
  }
  internal enum PlugLabel {
    /// No NFT
    internal static let text = L10n.tr("Localizable", "plugLabel.Text", fallback: "No NFT")
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
    /// Close
    internal static let close = L10n.tr("Localizable", "profile.close", fallback: "Close")
    /// About developer
    internal static let developer = L10n.tr("Localizable", "profile.developer", fallback: "About developer")
    /// Favorite NFTs
    internal static let favorite = L10n.tr("Localizable", "profile.favorite", fallback: "Favorite NFTs")
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
    /// My NFTs
    internal static let owned = L10n.tr("Localizable", "profile.owned", fallback: "My NFTs")
    /// Price
    internal static let price = L10n.tr("Localizable", "profile.price", fallback: "Price")
    /// Website
    internal static let site = L10n.tr("Localizable", "profile.site", fallback: "Website")
    /// Sorting
    internal static let sort = L10n.tr("Localizable", "profile.sort", fallback: "Sorting")
  }
  internal enum ProfileEdit {
    /// Change photo
    internal static let changePhoto = L10n.tr("Localizable", "profileEdit.changePhoto", fallback: "Change photo")
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
  internal enum StatisticActionSheep {
    /// By rating
    internal static let sortByName = L10n.tr("Localizable", "statisticActionSheep.sortByName", fallback: "By rating")
  }
  internal enum StatisticAlert {
    /// Sorting
    internal static let title = L10n.tr("Localizable", "statisticAlert.title", fallback: "Sorting")
  }
  internal enum StatisticErrorActionSheep {
    /// Repeat
    internal static let `repeat` = L10n.tr("Localizable", "statisticErrorActionSheep.repeat", fallback: "Repeat")
  }
  internal enum StatisticErrorAlert {
    /// Error
    internal static let title = L10n.tr("Localizable", "statisticErrorAlert.title", fallback: "Error")
  }
  internal enum StatisticErrorPlugView {
    /// Oops, something went wrong(
    internal static let text = L10n.tr("Localizable", "statisticErrorPlugView.text", fallback: "Oops, something went wrong(")
  }
  internal enum Statistics {
    /// Statistics
    internal static let icon = L10n.tr("Localizable", "statistics.icon", fallback: "Statistics")
  }
  internal enum UserCollectionButton {
    /// Collection NFT (%d)
    internal static func title(_ p1: Int) -> String {
      return L10n.tr("Localizable", "userCollectionButton.title", p1, fallback: "Collection NFT (%d)")
    }
  }
  internal enum UserCollectionViewController {
    /// Collection NFT
    internal static let title = L10n.tr("Localizable", "userCollectionViewController.Title", fallback: "Collection NFT")
  }
  internal enum UserSiteButton {
    /// Go to site
    internal static let title = L10n.tr("Localizable", "userSiteButton.Title", fallback: "Go to site")
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
