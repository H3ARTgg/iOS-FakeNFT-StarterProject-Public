import Foundation

protocol UserCollectionViewModelProtocol {
    var countUsers: Int { get }
    func nftCellViewModel(at index: Int) -> NftViewCellViewModel?
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol {
  
    private let nfts: [String]?
    
    init(nfts: [String]?) {
        self.nfts = nfts
    }
    
    public func nftCellViewModel(at index: Int) -> NftViewCellViewModel? {
        guard let nfts else { return nil }
        let nft = nfts[index]
        return NftViewCellViewModel(nft: nft)
    }
}

extension UserCollectionViewModel {
    var countUsers: Int {
        nfts?.count ?? 0
    }
}
