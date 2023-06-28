import Foundation

protocol NftViewCellViewModelProtocol {
    var imageURL: URL? { get }
    var nftName: String { get }
    var nftPrice: String? { get }
    var rating: Int { get }
    var isLiked: Bool { get }
}

final class NftViewCellViewModel: NftViewCellViewModelProtocol {
    private(set) var imageURL: URL?
    private(set) var nftName: String
    private(set) var nftPrice: String?
    private(set) var rating: Int
    private(set) var isLiked: Bool

    init(nft: Nft, isLiked: Bool) {
        imageURL = URL(string: nft.images.first ?? "Error")
        nftName = nft.name
        nftPrice = "\(String(format: "%.1f", nft.price)) ETH"
        rating = nft.rating
        self.isLiked = isLiked
    }    
}
