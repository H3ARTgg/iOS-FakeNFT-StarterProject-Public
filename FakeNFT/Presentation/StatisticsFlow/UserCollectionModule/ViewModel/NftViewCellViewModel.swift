import Foundation

protocol NftViewCellViewModelDelegate: AnyObject {
    func changeFavoritesForNFT(id: String)
    func changeNftInCart(id: String)
}

protocol NftViewCellViewModelProtocol {
    var setLike: ((Bool) -> Void)? { get set }
    var addToCart: ((Bool) -> Void)? { get set }
    
    var imageURL: URL? { get }
    var nftName: String { get }
    var nftPrice: String? { get }
    var rating: Int { get }
    var like: Bool { get }
    var isInCart: Bool { get }
    
    func likeButtonTapped()
    func cartButtonTapped()
}

final class NftViewCellViewModel: NftViewCellViewModelProtocol {
    var setLike: ((Bool) -> Void)?
    var addToCart: ((Bool) -> Void)?
    
    let imageURL: URL?
    let nftName: String
    let nftPrice: String?
    let rating: Int
    var like: Bool {
        isLike
    }
    var isInCart: Bool {
        didSet {
            addToCart?(isInCart)
        }
    }

    weak var delegate: NftViewCellViewModelDelegate?

    private let id: String
    
    private var isLike: Bool {
        didSet {
            setLike?(isLike)
        }
    }
    
    init(nft: NftResponseModel, isLiked: Bool, isInCart: Bool) {
        imageURL = URL(string: nft.images.first ?? "Error")
        nftName = nft.name
        nftPrice = "\(String(format: "%.1f", nft.price)) ETH"
        rating = nft.rating
        self.isLike = isLiked
        self.id = nft.id
        self.isInCart = isInCart
    }
    
    func likeButtonTapped() {
        delegate?.changeFavoritesForNFT(id: id)
        isLike.toggle()
    }

    func cartButtonTapped() {
        delegate?.changeNftInCart(id: id)
        isInCart.toggle()
    }
}
