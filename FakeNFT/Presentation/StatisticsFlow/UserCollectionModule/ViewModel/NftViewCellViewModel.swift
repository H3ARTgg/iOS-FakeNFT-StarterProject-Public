import Foundation

protocol NftViewCellViewModelProtocol {
    var imageURL: URL? { get }
    var nftName: String { get }
    var nftPrice: String? { get }
}

final class NftViewCellViewModel: NftViewCellViewModelProtocol {
    private(set) var imageURL: URL?
    private(set) var nftName: String
    private(set) var nftPrice: String?

    init(nft: Nft) {
        imageURL = URL(string: nft.images.first ?? "Error")
        nftName = nft.name
        nftPrice = "\(String(format: "%.1f", nft.price)) ETH"
    }
}
