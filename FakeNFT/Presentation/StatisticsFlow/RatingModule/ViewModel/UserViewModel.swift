import Foundation

protocol UserViewModelProtocol {
    var avatarURL: URL? { get }
    var userName: String { get }
    var countNFT: Int { get }
}

final class UserViewModel: UserViewModelProtocol {
    private(set) var avatarURL: URL?
    private(set) var userName: String
    private(set) var countNFT: Int
    
    init(user: User) {
        self.avatarURL = URL(string: user.avatar)
        self.userName = user.name
        self.countNFT = user.nfts?.count ?? 0
    }
}
