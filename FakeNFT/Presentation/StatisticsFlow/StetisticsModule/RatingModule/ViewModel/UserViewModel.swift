import Foundation

protocol UserViewModelProtocol {
   var photo: String { get }
   var userName: String { get }
   var countNFT: Int { get }
}

final class UserViewModel: UserViewModelProtocol {
   private(set) var photo: String
   private(set) var userName: String
   private(set) var countNFT: Int
    
    init(user: User) {
        self.photo = user.photo
        self.userName = user.name
        self.countNFT = user.nftCollection?.count ?? 0
    }
}
