import Foundation

protocol NftViewCellViewModelProtocol {
    var setLike: ((Bool) -> Void)? { get set }
    
    var imageURL: URL? { get }
    var nftName: String { get }
    var nftPrice: String? { get }
    var rating: Int { get }
    var like: Bool { get }
    
    func likeButtonTapped()
}

final class NftViewCellViewModel: NftViewCellViewModelProtocol {
    var setLike: ((Bool) -> Void)?
    
    let imageURL: URL?
    let nftName: String
    let nftPrice: String?
    let rating: Int
    var like: Bool {
        isLike
    }
    
    private(set) var isLike: Bool {
        didSet {
            setLike?(isLike)
        }
    }
    
    init(nft: NftNetworkModel, isLiked: Bool) {
        imageURL = URL(string: nft.images.first ?? "Error")
        nftName = nft.name
        nftPrice = "\(String(format: "%.1f", nft.price)) ETH"
        rating = nft.rating
        self.isLike = isLiked
        likeButtonTapped()
    }
    
    func likeButtonTapped() {
        isLike.toggle()
    }
}
