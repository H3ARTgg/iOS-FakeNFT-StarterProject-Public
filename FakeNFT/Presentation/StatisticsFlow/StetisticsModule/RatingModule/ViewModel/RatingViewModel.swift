import Foundation

protocol RatingViewModelProtocol {
    var updateViewData: ((Bool) -> Void)? { get set }
    var countUsers: Int { get }
    var headForAlert: ((AlertModel) -> Void)? { get set }
    func updateUsers()
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel
    func showActionSheep()
}

final class RatingViewModel {
    public var updateViewData: ((Bool) -> Void)?
    public var headForAlert: ((AlertModel) -> Void)?
    
    private let users = User.users.sorted { user1, user2 in
        user1.nftCollectionCount > user2.nftCollectionCount
    }
}

extension RatingViewModel: RatingViewModelProtocol {
    
    public func updateUsers() {
        updateViewData?(true)
    }
    
    public var countUsers: Int {
        users.count
    }
    
    public func viewModelForCell(at index: Int) -> UserTableViewCellViewModel {
        let user = users[index]
        let positionInRating = getUserPositionInRating(by: user)
        let viewModel = UserTableViewCellViewModel(user: user, positionInRating: positionInRating)
        return viewModel
    }
    
    public func showActionSheep() {
        let alertModel = creatAlertModel()
        headForAlert?(alertModel)
    }
    
    func getUserPositionInRating(by user: User) -> Int {
        (users.firstIndex(of: user) ?? 0) + 1
    }
    
    func creatAlertModel() -> AlertModel {
        let alertText = Consts.LocalizedStrings.statisticAlertTitle
        let alertSortByNameActionText = Consts.LocalizedStrings.statisticActionSheepName
        let alertSortByRaringActionText = Consts.LocalizedStrings.statisticActionSheepRating
        let alertCancelText = Consts.LocalizedStrings.alertCancelText
        
        let alertSortBynameAction = AlertAction(
            actionText: alertSortByNameActionText,
            actionRole: .regular,
            action: {
                // TODO: sort by name
            })
        
        let alertSortBynameRating = AlertAction(
            actionText: alertSortByRaringActionText,
            actionRole: .regular,
            action: {
                // TODO: sort by rating
            })
        let alertCancelAction = AlertAction(actionText: alertCancelText, actionRole: .cancel, action: nil)
        let alertModel = AlertModel(
            alertText: alertText,
            alertActions: [alertSortBynameAction, alertSortBynameRating, alertCancelAction]
        )
        return alertModel
    }
}
