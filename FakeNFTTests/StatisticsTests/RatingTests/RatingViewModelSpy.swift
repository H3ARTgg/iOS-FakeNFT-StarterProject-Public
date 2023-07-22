import Foundation
@testable import FakeNFT

final class RatingViewModelSpy: RatingViewModelProtocol {
    var showTableView: ((Bool) -> Void)?
    var showPlugView: ((Bool, String?) -> Void)?
    
    lazy var countUsers: Int = users.count
    
    var statisticProvider: StatisticProviderProtocol
    let sortingStore: SortStatisticStoreProtocol
    
    var users: [UserNetworkModel] = [] {
        didSet {
            if users.isEmpty {
                showTableView?(false)
                showPlugView?(true, "TestText")
                
            } else {
                showTableView?(true)
                showPlugView?(false, nil)
            }
        }
    }
    var selectedUser: UserNetworkModel?
    var sortedButtonStatus = false
    
    init(statisticProvider: StatisticProviderProtocol, sortStore: SortStatisticStoreProtocol) {
        self.statisticProvider = statisticProvider
        self.sortingStore = sortStore
    }
    
    func didSelectUser(at index: Int) {
        selectedUser = users[index]
    }
    
    func sortedButtonTapped() {
        sortedButtonStatus = true
    }
    
    func fetchUsers() {
        statisticProvider.fetchUsersNextPage { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.users = model
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func viewModelForCell(at index: Int) -> FakeNFT.UserTableViewCellViewModel {
        UserTableViewCellViewModel(user: users[index])
    }
    
    func viewModelForUserCard(at index: Int) -> FakeNFT.UserNetworkModel {
        users[index]
    }
}
