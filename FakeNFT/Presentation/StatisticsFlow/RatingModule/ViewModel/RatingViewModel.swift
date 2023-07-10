import Foundation

protocol RatingViewModelProtocol {
    var headForAlert: ((AlertModel) -> Void)? { get set }
    var showTableView: ((Bool) -> Void)? { get set }
    
    var countUsers: Int { get }
    
    func fetchUsers()
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel
    func viewModelForUserCard(at index: Int) -> UserCardViewModel
    func showActionSheet()
}

final class RatingViewModel {
    var headForAlert: ((AlertModel) -> Void)?
    var showTableView: ((Bool) -> Void)?
    
    private var statisticProvider: StatisticProviderProtocol?
    private var sortingStore: SortStatisticStoreProtocol
    
    private lazy var filter: StatisticFilter = sortingStore.getSortFilter {
        didSet {
            showTableView?(false)
            fetchedUsers = sortUsers(users: fetchedUsers)
        }
    }
    
    private var fetchedUsers: [UserNetworkModel] = [] {
        didSet {
            showTableView?(true)
        }
    }
    
    init(statisticProvider: StatisticProviderProtocol? = nil, sortStore: SortStatisticStoreProtocol) {
        self.statisticProvider = statisticProvider
        self.sortingStore = sortStore
        getUsers()
    }
    
    private func getUsers() {
        statisticProvider?.fetchUsersNextPage(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let users):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.fetchedUsers = self.sortUsers(users: users)
                }
            case .failure(let failure):
                // TODO: show error alert
                print("not internet \(failure.localizedDescription)")
            }
        })
    }
}

extension RatingViewModel: RatingViewModelProtocol {
    var countUsers: Int {
        fetchedUsers.count
    }
    
    func fetchUsers() {
        getUsers()
    }
    
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel {
        let user = fetchedUsers[index]
        let viewModel = UserTableViewCellViewModel(user: user)
        return viewModel
    }
    
    func viewModelForUserCard(at index: Int) -> UserCardViewModel {
        let user = fetchedUsers[index]
        let viewModel = UserCardViewModel(user: user)
        return viewModel
    }
    
    func showActionSheet() {
        let alertModel = createAlertModel()
        headForAlert?(alertModel)
    }
    
    func sortUsers(users: [UserNetworkModel]) -> [UserNetworkModel] {
        switch filter {
        case .name:
            return users.sorted(by: {
                $0 < $1
            })
        case .rating:
            return users.sorted(by: {
                $0.intUserRating < $1.intUserRating
            })
        }
    }
    
    private func createAlertModel() -> AlertModel {
        let alertText = Consts.LocalizedStrings.statisticAlertTitle
        let alertSortByNameActionText = Consts.LocalizedStrings.statisticActionSheepName
        let alertSortByRaringActionText = Consts.LocalizedStrings.statisticActionSheepRating
        let alertCancelText = Consts.LocalizedStrings.alertCancelText
        
        let alertSortByNameAction = AlertAction(
            actionText: alertSortByNameActionText,
            actionRole: .regular,
            action: { [weak self] in
                guard let self else { return }
                self.sortingStore.setSortFilter(filter: .name)
                self.filter = .name
            })
        
        let alertSortByNameRating = AlertAction(
            actionText: alertSortByRaringActionText,
            actionRole: .regular,
            action: { [weak self] in
                guard let self else { return }
                self.sortingStore.setSortFilter(filter: .rating)
                self.filter = .rating
            })
        let alertCancelAction = AlertAction(actionText: alertCancelText, actionRole: .cancel, action: nil)
        let alertModel = AlertModel(
            alertText: alertText,
            alertActions: [alertSortByNameAction, alertSortByNameRating, alertCancelAction]
        )
        return alertModel
    }
}
