import Foundation

protocol UserTableViewCellViewModelProtocol {
    var positionInRating: Int { get }
    var user: User { get }
    func getViewModelForUserView() -> UserViewModel
}

final class UserTableViewCellViewModel: UserTableViewCellViewModelProtocol {
    private(set) var positionInRating: Int
    let user: User
    
    init(user: User, positionInRating: Int) {
        self.positionInRating = positionInRating
        self.user = user
    }
    
    func getViewModelForUserView() -> UserViewModel {
        return UserViewModel(user: user)
    }
}
