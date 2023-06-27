import Foundation

protocol UserCollectionViewModelProtocol {
    var updateViewData: ((Bool) -> Void)? { get set }
    var hideCollectionViewView: ((Bool) -> Void)? { get set }
    var showCollectionView: ((Bool) -> Void)? { get set }
    
    var countUsers: Int { get }
    func nftCellViewModel(at index: Int) -> NftViewCellViewModel
    func fetchNft()
    func refreshNft()
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol {
    public var updateViewData: ((Bool) -> Void)?
    public var hideCollectionViewView: ((Bool) -> Void)?
    public var showCollectionView: ((Bool) -> Void)?
    
    private var nftsId: [String]? 
    
    private var nfts: [Nft] = [] {
        didSet {
            guard let nftsId,
            !nftsId.isEmpty else {
                showCollectionView?(true)
                return
            }
            if nfts.count == nftsId.count {
                updateViewData?(true)
                showCollectionView?(true)
            }
        }
    }
    
    private let nftsProvider: NftProviderProtocol
    
    init(nftsId: [String]?, nftsProvider: NftProviderProtocol) {
        self.nftsProvider = nftsProvider
        self.nftsId = nftsId
    }
    
    public func nftCellViewModel(at index: Int) -> NftViewCellViewModel {
        let nft = nfts[index]
        return NftViewCellViewModel(nft: nft)
    }
    
    public func fetchNft() {
        hideCollectionViewView?(true)
        guard let nftsId else { return }
        nftsId.forEach({ [weak self] id in
            nftsProvider.fetchNft(id: id) { result in
                switch result {
                case .success(let nft):
                    DispatchQueue.main.async {
                        self?.nfts.append(nft)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        })
    }
    
    public func refreshNft() {
        nfts = []
        fetchNft()
    }
}

extension UserCollectionViewModel {
    var countUsers: Int {
        nfts.count
    }
}
