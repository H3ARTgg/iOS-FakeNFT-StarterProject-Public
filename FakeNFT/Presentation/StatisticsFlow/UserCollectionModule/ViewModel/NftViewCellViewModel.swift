import Foundation

protocol NftViewCellViewModelProtocol {
    
}

final class NftViewCellViewModel: NftViewCellViewModelProtocol {
    private let nft: String
    
    init(nft: String) {
        self.nft = nft
    }
}
