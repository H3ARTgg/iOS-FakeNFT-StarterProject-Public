import Foundation

enum SortOption: String {
    case sortPrice
    case sortRating
    case sortTitle
    case none
}

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let sortOptionKey = "SortOption"

    var sortOption: SortOption {
        get {
            if let sortOptionString = userDefaults.string(forKey: sortOptionKey),
               let sortOption = SortOption(rawValue: sortOptionString) {
                return sortOption
            } else {
                return .none
            }
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: sortOptionKey)
        }
    }
    
    private init() {}
}
