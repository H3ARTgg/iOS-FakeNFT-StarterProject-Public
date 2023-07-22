import Foundation

protocol UserTableViewCellViewModelProtocol {
    var positionInRating: String { get }
    func getViewModelForUserView() -> UserViewModel
}

final class UserTableViewCellViewModel: UserTableViewCellViewModelProtocol {
    private(set) var positionInRating: String
    private let user: UserNetworkModel
    
    init(user: UserNetworkModel) {
        self.positionInRating = String(user.rating) 
        self.user = user
    }
    
    func getViewModelForUserView() -> UserViewModel {
        return UserViewModel(user: user)
    }
}
