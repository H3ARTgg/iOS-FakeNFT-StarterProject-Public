import Foundation

protocol UserCardCoordination {
    var headForAbout: ((URL) -> Void)? { get set }
    var headForUserCollection: (([String]?) -> Void)? { get set }
}

protocol UserCardViewModelProtocol {
    var avatarURL: URL? { get }
    var userName: String { get }
    var description: String { get }
    var website: URL? { get }
    var nfts: [String]? { get }
    
    func showUserSiteButtonTapped()
    func showUserCollectionButtonTapped()
}

final class UserCardViewModel: UserCardViewModelProtocol, UserCardCoordination {
    var headForAbout: ((URL) -> Void)?
    var headForUserCollection: (([String]?) -> Void)?
    
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
    
    func showUserSiteButtonTapped() {
        guard let website else { return }
        headForAbout?(website)
    }
    
    func showUserCollectionButtonTapped() {
        headForUserCollection?(nfts)
    }
}
