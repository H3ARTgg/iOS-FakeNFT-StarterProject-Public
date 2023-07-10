import Foundation

protocol NftViewCellViewModelProtocol {
    var imageURL: URL? { get }
    var nftName: String { get }
    var nftPrice: String? { get }
    var rating: Int { get }
    var isLiked: Bool { get }
}

final class NftViewCellViewModel: NftViewCellViewModelProtocol {
    let imageURL: URL?
    let nftName: String
    let nftPrice: String?
    let rating: Int
    let isLiked: Bool
    
    init(nft: NftNetworkModel, isLiked: Bool) {
        imageURL = URL(string: nft.images.first ?? "Error")
        nftName = nft.name
        nftPrice = "\(String(format: "%.1f", nft.price)) ETH"
        rating = nft.rating
        self.isLiked = isLiked
    }
}
