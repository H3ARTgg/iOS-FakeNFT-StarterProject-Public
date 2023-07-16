import Foundation

protocol StatisticCoordination: AnyObject {
    var headForUserCard: ((UserNetworkModel) -> Void)? { get set }
    var headForActionSheet: ((AlertModel) -> Void)? { get set }
    var headForAlert: ((AlertModel) -> Void)? { get set }
}

protocol RatingViewModelProtocol {
    var showTableView: ((Bool) -> Void)? { get set }
    var showPlugView: ((Bool, String?) -> Void)? { get set }
    
    var countUsers: Int { get }
    
    func didSelectUser(at index: Int)
    func sortedButtonTapped()
    
    func fetchUsers()
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel?
    func viewModelForUserCard(at index: Int) -> UserNetworkModel
}

final class RatingViewModel: StatisticCoordination {
    var headForUserCard: ((UserNetworkModel) -> Void)?
    var headForActionSheet: ((AlertModel) -> Void)?
    var headForAlert: ((AlertModel) -> Void)?
    
    var showTableView: ((Bool) -> Void)?
    var showPlugView: ((Bool, String?) -> Void)?
    
    private var statisticProvider: StatisticProviderProtocol?
    private var sortingStore: SortStatisticStoreProtocol
    private let errorHandler: ErrorHandlerProtocol
    
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
    
    init(statisticProvider: StatisticProviderProtocol? = nil, sortStore: SortStatisticStoreProtocol, errorHandler: ErrorHandlerProtocol) {
        self.statisticProvider = statisticProvider
        self.sortingStore = sortStore
        self.errorHandler = errorHandler
        getUsers()
    }
    
    private func getUsers() {
        statisticProvider?.fetchUsersNextPage(completion: { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.showPlugView?(false, nil)
                    self.fetchedUsers = self.sortUsers(users: users)
                case .failure(let failure):
                    self.showPlugView?(true, L10n.Statistic.ErrorPlugView.text)
                    self.showErrorAlert(message: failure.localizedDescription)
                }
            }
        })
    }
}

extension RatingViewModel: RatingViewModelProtocol {
    var countUsers: Int {
        fetchedUsers.count
    }
    
    func didSelectUser(at index: Int) {
        let userCard = viewModelForUserCard(at: index)
        headForUserCard?(userCard)
    }
    
    func fetchUsers() {
        fetchedUsers.removeAll()
        getUsers()
    }
    
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel? {
        guard !fetchedUsers.isEmpty else { return nil }
        let user = fetchedUsers[index]
        let viewModel = UserTableViewCellViewModel(user: user)
        return viewModel
    }
    
    func viewModelForUserCard(at index: Int) -> UserNetworkModel {
        let user = fetchedUsers[index]
        return user
    }
    
    func sortedButtonTapped() {
        let alertModel = createSortAlertModel()
        headForActionSheet?(alertModel)
    }
    
    func sortUsers(users: [UserNetworkModel]) -> [UserNetworkModel] {
        switch filter {
        case .name:
            return users.sorted(by: < )
        case .rating:
            return users.sorted(by: {
                $0.intUserRating < $1.intUserRating
            })
        }
    }
    
    func createSortAlertModel() -> AlertModel {
        let alertText = L10n.Statistic.FilterAlert.title
        let alertSortByNameActionText = L10n.Statistic.AlertAction.SortByName.title
        let alertSortByRaringActionText = L10n.Statistic.AlertAction.SortByRating.title
        let alertCancelText = L10n.Statistic.AlertAction.Cancel.title
        
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
            message: nil,
            alertActions: [alertSortByNameAction, alertSortByNameRating, alertCancelAction]
        )
        return alertModel
    }
    
    func showErrorAlert(message: String) {
        let alertModel = errorHandler.createErrorAlertModel(message: message) { [weak self] in
            guard let self else { return }
            self.fetchUsers()
        }
        headForAlert?(alertModel)
    }
}
