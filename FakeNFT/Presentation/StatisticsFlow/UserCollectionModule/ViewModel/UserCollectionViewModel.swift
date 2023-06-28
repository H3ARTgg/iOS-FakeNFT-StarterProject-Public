import Foundation

protocol UserCollectionViewModelProtocol {
    var updateViewData: ((Bool) -> Void)? { get set }
    var hideCollectionView: ((Bool) -> Void)? { get set }
    var showCollectionView: ((Bool) -> Void)? { get set }
    var showPlugView: ((String) -> Void)? { get set }
    
    var countUsers: Int { get }
    func nftCellViewModel(at index: Int) -> NftViewCellViewModel
    func fetchNft()
    func refreshNft()
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol {
    public var updateViewData: ((Bool) -> Void)?
    public var hideCollectionView: ((Bool) -> Void)?
    public var showCollectionView: ((Bool) -> Void)?
    public var showPlugView: ((String) -> Void)?
    
    private var nftsId: [String]? 
    
    private var nfts: [Nft] = [] {
        didSet {
            guard let nftsId
            else {
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
        // TODO: необходимо проверить ставил ли лайк наш профиль этому NFT
        return NftViewCellViewModel(nft: nft, isLiked: false)
    }
    
    public func fetchNft() {
        guard let nftsId else { return }
        guard !nftsId.isEmpty else {
            showPlugView?(Consts.LocalizedStrings.plugLabelText)
            return
        }
        hideCollectionView?(true)
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
