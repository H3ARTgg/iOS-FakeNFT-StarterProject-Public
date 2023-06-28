import Foundation

protocol UserTableViewCellViewModelProtocol {
    var positionInRating: String { get }
    var user: User { get }
    func getViewModelForUserView() -> UserViewModel
}

final class UserTableViewCellViewModel: UserTableViewCellViewModelProtocol {
    private(set) var positionInRating: String
    let user: User
    
    init(user: User) {
        self.positionInRating = String(user.rating) 
        self.user = user
    }
    
    func getViewModelForUserView() -> UserViewModel {
        return UserViewModel(user: user)
    }
}
