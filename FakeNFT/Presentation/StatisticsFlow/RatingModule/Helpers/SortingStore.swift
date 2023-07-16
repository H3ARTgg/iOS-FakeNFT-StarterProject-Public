import Foundation

protocol SortStatisticStoreProtocol {
    var getSortFilter: StatisticFilter { get }
    func setSortFilter(filter: StatisticFilter)
}

final class SortingStore {
    private let userDefault = UserDefaults.standard
    
    private var sortFilter: StatisticFilter? {
        get {
            guard let filter = userDefault.string(forKey: CodingKeys.sort.rawValue) else { return nil }
            return StatisticFilter(rawValue: filter)
        }
        set(filter) {
            userDefault.set(filter?.rawValue, forKey: CodingKeys.sort.rawValue)
        }
    }
}

extension SortingStore {
    private enum CodingKeys: String, CodingKey {
        case sort
    }
}

extension SortingStore: SortStatisticStoreProtocol {
    var getSortFilter: StatisticFilter {
        guard let sortFilter = sortFilter else {
            self.sortFilter = .rating
            return .rating
        }
        return sortFilter
    }
    
    func setSortFilter(filter: StatisticFilter) {
        sortFilter = filter
    }
}
