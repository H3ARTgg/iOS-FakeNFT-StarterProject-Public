import Foundation

protocol RatingViewModelProtocol {
    var headForAlert: ((AlertModel) -> Void)? { get set }
    var addUsers: (((oldValue: Int, newValue: Int)) -> Void)? { get set }
    var updateViewData: ((Bool) -> Void)? { get set }
    var hideTableView: ((Bool) -> Void)? { get set }
    var showTableView: ((Bool) -> Void)? { get set }
    
    var countUsers: Int { get }
    
    func updateUsers()
    func fetchUsers()
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel
    func showActionSheep()
    func checkUsers()
}

final class RatingViewModel {
    public var headForAlert: ((AlertModel) -> Void)?
    public var addUsers: (((oldValue: Int, newValue: Int)) -> Void)?
    public var updateViewData: ((Bool) -> Void)?
    public var hideTableView: ((Bool) -> Void)?
    public var showTableView: ((Bool) -> Void)?
    
    private var statisticProvider: StatisticProviderProtocol?
    
    private lazy var oldUsersCount = users.count
    private lazy var newUsersCount = 0
    private var isRefresh: Bool = false
    private var filter: StatisticFilter = .name
    
    private var users: [User] = [] {
        didSet {
            newUsersCount = users.count
            checkUpdate()
            showTableView?(true)
        }
    }
        
    init(statisticProvider: StatisticProviderProtocol? = nil) {
        self.statisticProvider = statisticProvider
        getUsers()
    }
    
    private func getUsers() {
        statisticProvider?.fetchUsersNextPage(isRefresh: isRefresh, filter: filter, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let users):
                self.oldUsersCount = self.users.count
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    if self.isRefresh {
                        self.oldUsersCount = users.count
                        self.users = users
                    } else {
                        self.users += users
                    }
                }
            case .failure(let failure):
                // TODO: show error alert
                print("not internet")
            }
        })
    }
}

extension RatingViewModel: RatingViewModelProtocol {
    public func fetchUsers() {
        isRefresh = false
        getUsers()
    }
    
    public func updateUsers() {
        hideTableView?(true)
        isRefresh = true
        getUsers()
    }
    
    public var countUsers: Int {
        users.count
    }
    
    public func viewModelForCell(at index: Int) -> UserTableViewCellViewModel {
        let user = users[index]
        let viewModel = UserTableViewCellViewModel(user: user)
        return viewModel
    }
    
    public func showActionSheep() {
        let alertModel = createAlertModel()
        headForAlert?(alertModel)
    }
    
    public func sortByName() {
        hideTableView?(true)
        filter = .name
        updateUsers()
    }
    
    public func sortByRating() {
        hideTableView?(true)
        filter = .rating
        updateUsers()
    }
    
    public func checkUsers() {
        if users.isEmpty {
            hideTableView?(true)
            fetchUsers()
        } else {
            showTableView?(true)
        }
    }
    
    func checkUpdate() {
        if isRefresh {
            updateViewData?(true)
        } else {
            addUsers?((oldUsersCount, newUsersCount))
        }
    }
    
    func createAlertModel() -> AlertModel {
        let alertText = Consts.LocalizedStrings.statisticAlertTitle
        let alertSortByNameActionText = Consts.LocalizedStrings.statisticActionSheepName
        let alertSortByRaringActionText = Consts.LocalizedStrings.statisticActionSheepRating
        let alertCancelText = Consts.LocalizedStrings.alertCancelText
        isRefresh = true
        
        let alertSortBynameAction = AlertAction(
            actionText: alertSortByNameActionText,
            actionRole: .regular,
            action: { [weak self] in
                guard let self else { return }
                self.sortByName()
            })
        
        let alertSortBynameRating = AlertAction(
            actionText: alertSortByRaringActionText,
            actionRole: .regular,
            action: { [weak self] in
                guard let self else { return }
                self.sortByRating()
            })
        let alertCancelAction = AlertAction(actionText: alertCancelText, actionRole: .cancel, action: nil)
        let alertModel = AlertModel(
            alertText: alertText,
            alertActions: [alertSortBynameAction, alertSortBynameRating, alertCancelAction]
        )
        return alertModel
    }

}
