import Foundation

protocol UserViewModelProtocol {
   var avatar: String { get }
   var userName: String { get }
   var countNFT: Int { get }
}

final class UserViewModel: UserViewModelProtocol {
   private(set) var avatar: String
   private(set) var userName: String
   private(set) var countNFT: Int
    
    init(user: User) {
        self.avatar = user.avatar
        self.userName = user.name
        self.countNFT = user.nfts?.count ?? 0
    }
}
