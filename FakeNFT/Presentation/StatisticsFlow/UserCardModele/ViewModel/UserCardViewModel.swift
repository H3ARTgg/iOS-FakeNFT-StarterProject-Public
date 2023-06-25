import Foundation

protocol UserCardViewModelProtocol {
    var avatarURL: URL? { get }
    var userName: String { get }
    var description: String { get }
    var website: URL? { get }
    var nfts: [String]? { get }
}

final class UserCardViewModel: UserCardViewModelProtocol {
   private(set) var avatarURL: URL?
   private(set) var userName: String
   private(set) var description: String
   private(set) var website: URL?
   private(set) var nfts: [String]?
    
    init(user: User) {
        avatarURL = URL(string: user.avatar)
        userName = user.name
        description = user.description
        website = URL(string: user.website)
        nfts = user.nfts
    }
}
