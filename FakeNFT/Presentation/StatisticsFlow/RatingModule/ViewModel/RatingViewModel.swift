import Foundation

protocol StatisticCoordination: AnyObject {
    var headForUserCard: ((UserNetworkModel) -> Void)? { get set }
    var headForActionSheet: ((AlertModel) -> Void)? { get set }
    var headForAlert: ((AlertModel) -> Void)? { get set }
}

protocol RatingViewModelProtocol {
    var showTableView: ((Bool) -> Void)? { get set }
    var countUsers: Int { get }
    
    func didSelectUser(at index: Int)
    func sortedButtonTapped()
    
    func fetchUsers()
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel
    func viewModelForUserCard(at index: Int) -> UserNetworkModel
}

final class RatingViewModel: StatisticCoordination {
    var headForUserCard: ((UserNetworkModel) -> Void)?
    var headForActionSheet: ((AlertModel) -> Void)?
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
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.fetchedUsers = self.sortUsers(users: users)
                case .failure(let failure):
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
        getUsers()
    }
    
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel {
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
            return users.sorted(by: {
                $0 < $1
            })
        case .rating:
            return users.sorted(by: {
                $0.intUserRating < $1.intUserRating
            })
        }
    }
    
    func createSortAlertModel() -> AlertModel {
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
            message: nil,
            alertActions: [alertSortByNameAction, alertSortByNameRating, alertCancelAction]
        )
        return alertModel
    }
    
    func showErrorAlert(message: String) {
        let alertModel = createErrorAlertModel(message: message)
        headForAlert?(alertModel)
    }
    
    func createErrorAlertModel(message: String) -> AlertModel {
        let alertText = Consts.LocalizedStrings.statisticErrorAlertTitle
        let alertRepeatActionText = Consts.LocalizedStrings.statisticErrorActionSheepNameRepeat
        let alertCancelText = Consts.LocalizedStrings.alertCancelText
        
        let alertRepeatAction = AlertAction(
            actionText: alertRepeatActionText,
            actionRole: .regular,
            action: { [weak self] in
                guard let self else { return }
                // self.refreshNft()
            })
        
        let alertCancelAction = AlertAction(actionText: alertCancelText, actionRole: .cancel, action: nil)
        
        let alertModel = AlertModel(
            alertText: alertText,
            message: message,
            alertActions: [alertCancelAction, alertRepeatAction]
        )
        return alertModel
    }
}
