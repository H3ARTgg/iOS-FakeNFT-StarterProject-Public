import Foundation

protocol UserCardCoordination {
    var headForAbout: ((String) -> Void)? { get set }
    var headForUserCollection: (([String]?) -> Void)? { get set }
}

protocol UserCardViewModelProtocol {
    var avatarURL: URL? { get }
    var userName: String { get }
    var description: String { get }
    var website: String { get }
    var nfts: [String]? { get }
    
    func showUserSiteButtonTapped()
    func showUserCollectionButtonTapped()
}

final class UserCardViewModel: UserCardViewModelProtocol, UserCardCoordination {
    var headForAbout: ((String) -> Void)?
    var headForUserCollection: (([String]?) -> Void)?
    
    let avatarURL: URL?
    let userName: String
    let description: String
    let website: String
    let nfts: [String]?
    
    init(user: UserNetworkModel) {
        avatarURL = URL(string: user.avatar)
        userName = user.name
        description = user.description
        website = user.website
        nfts = user.nfts
    }
    
    func showUserSiteButtonTapped() {
        headForAbout?(website)
    }
    
    func showUserCollectionButtonTapped() {
        headForUserCollection?(nfts)
    }
}
