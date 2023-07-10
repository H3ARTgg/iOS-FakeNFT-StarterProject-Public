import Foundation

protocol UserCardViewModelProtocol {
    var avatarURL: URL? { get }
    var userName: String { get }
    var description: String { get }
    var website: URL? { get }
    var nfts: [String]? { get }
}

final class UserCardViewModel: UserCardViewModelProtocol {
    let avatarURL: URL?
    let userName: String
    let description: String
    let website: URL?
    let nfts: [String]?
    
    init(user: UserNetworkModel) {
        avatarURL = URL(string: user.avatar)
        userName = user.name
        description = user.description
        website = URL(string: user.website)
        nfts = user.nfts
    }
}
