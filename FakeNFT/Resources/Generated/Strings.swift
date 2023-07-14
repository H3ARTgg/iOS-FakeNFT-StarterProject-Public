// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
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
  internal enum Cart {
    /// Cart
    internal static let icon = L10n.tr("Localizable", "cart.icon", fallback: "Cart")
  }
  internal enum Catalogue {
    /// Catalogue
    internal static let icon = L10n.tr("Localizable", "catalogue.icon", fallback: "Catalogue")
  }
  internal enum Profile {
    /// Profile
    internal static let icon = L10n.tr("Localizable", "profile.icon", fallback: "Profile")
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
