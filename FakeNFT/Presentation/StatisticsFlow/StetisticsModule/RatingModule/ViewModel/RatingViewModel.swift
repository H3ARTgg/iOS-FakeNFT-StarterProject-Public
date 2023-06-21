import Foundation

protocol RatingViewModelProtocol {
    var countUsers: Int { get }
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel
}

final class RatingViewModel {
    private let users = User.users.sorted { user1, user2 in
        user1.nftCollectionCount > user2.nftCollectionCount
    }
}

extension RatingViewModel: RatingViewModelProtocol {
    var countUsers: Int {
        users.count
    }
    
    func viewModelForCell(at index: Int) -> UserTableViewCellViewModel {
        let user = users[index]
        let positionInRating = getUserPositionInRating(by: user)
        let viewModel = UserTableViewCellViewModel(user: user, positionInRating: positionInRating)
        return viewModel
    }
    
    func getUserPositionInRating(by user: User) -> Int {
        (users.firstIndex(of: user) ?? 0) + 1
    }
}
