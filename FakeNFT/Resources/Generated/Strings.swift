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
  internal enum Cart {
    /// Cart
    internal static let icon = L10n.tr("Localizable", "cart.icon", fallback: "Cart")
  }
  internal enum Catalogue {
    /// Catalogue
    internal static let icon = L10n.tr("Localizable", "catalogue.icon", fallback: "Catalogue")
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
    /// Price
    internal static let price = L10n.tr("Localizable", "profile.price", fallback: "Price")
    /// Website
    internal static let site = L10n.tr("Localizable", "profile.site", fallback: "Website")
    /// Sorting
    internal static let sort = L10n.tr("Localizable", "profile.sort", fallback: "Sorting")
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
