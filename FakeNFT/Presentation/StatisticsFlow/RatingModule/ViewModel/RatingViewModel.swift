import Foundation

protocol RatingViewModelProtocol {
    var headForAlert: ((AlertModel) -> Void)? { get set }
    var updateViewData: ((Bool) -> Void)? { get set }
    var hideTableView: ((Bool) -> Void)? { get set }
    var showTableView: ((Bool) -> Void)? { get set }
    
    var countUsers: Int { get }
    
    func fetchUsers()
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel
    func viewModelForUserCard(at index: Int) -> UserCardViewModel
    func showActionSheet()
    func checkUsers()
}

final class RatingViewModel {
    public var headForAlert: ((AlertModel) -> Void)?
    public var updateViewData: ((Bool) -> Void)?
    public var hideTableView: ((Bool) -> Void)?
    public var showTableView: ((Bool) -> Void)?
    
    private var statisticProvider: StatisticProviderProtocol?
    
    private lazy var filter: StatisticFilter = .rating
    
    private var sortedUsers: [User] = [] {
        didSet {
            showTableView?(true)
            updateViewData?(true)
        }
    }
    
    private var fetchedUsers: [User] = [] {
        didSet {
            sortUsers()
        }
    }
    
    private var nameSorting: [User ] {
        fetchedUsers.sorted(by: {
            $0 < $1
        })
    }
    
    private var ratingSorting: [User ] {
        fetchedUsers.sorted(by: {
            $0.rating < $1.rating
        })
    }
    
    init(statisticProvider: StatisticProviderProtocol? = nil) {
        self.statisticProvider = statisticProvider
        getUsers()
    }
    
    private func getUsers() {
        statisticProvider?.fetchUsersNextPage(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let users):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.fetchedUsers = users
                }
            case .failure(let failure):
                // TODO: show error alert
                print("not internet \(failure.localizedDescription)")
            }
        })
    }
    
    private func sortUsers() {
        hideTableView?(true)
        switch self.filter {
        case .name:
            self.sortedUsers = self.nameSorting
        case .rating:
            self.sortedUsers = self.ratingSorting
        }
    }
}

extension RatingViewModel: RatingViewModelProtocol {
    public var countUsers: Int {
        sortedUsers.count
    }
    
    public func fetchUsers() {
        getUsers()
    }
    
    public func viewModelForCell(at index: Int) -> UserTableViewCellViewModel {
        let user = sortedUsers[index]
        let viewModel = UserTableViewCellViewModel(user: user)
        return viewModel
    }
    
    public func viewModelForUserCard(at index: Int) -> UserCardViewModel {
        let user = sortedUsers[index]
        let viewModel = UserCardViewModel(user: user)
        return viewModel
    }
    
    public func showActionSheet() {
        let alertModel = createAlertModel()
        headForAlert?(alertModel)
    }
    
    public func checkUsers() {
        if sortedUsers.isEmpty {
            hideTableView?(true)
            fetchUsers()
        } else {
            showTableView?(true)
        }
    }
    
    private func sortByName() {
        filter = .name
        sortUsers()
    }
    
    private func sortByRating() {
        filter = .rating
        sortUsers()
    }
    
    private func createAlertModel() -> AlertModel {
        let alertText = Consts.LocalizedStrings.statisticAlertTitle
        let alertSortByNameActionText = Consts.LocalizedStrings.statisticActionSheepName
        let alertSortByRaringActionText = Consts.LocalizedStrings.statisticActionSheepRating
        let alertCancelText = Consts.LocalizedStrings.alertCancelText
        
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
