import Foundation
@testable import FakeNFT

final class SortingStoreSpy: SortStatisticStoreProtocol {
    var getSortFilter: StatisticFilter = .rating
    
    func setSortFilter(filter: StatisticFilter) {
        getSortFilter = filter
    }
}
