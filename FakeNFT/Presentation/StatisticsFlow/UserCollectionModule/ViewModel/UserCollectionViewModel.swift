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
    var updateViewData: ((Bool) -> Void)?
    var hideCollectionView: ((Bool) -> Void)?
    var showCollectionView: ((Bool) -> Void)?
    var showPlugView: ((String) -> Void)?
    
    private var nftsId: [String]?
    
    private var nfts: [NftNetworkModel] = [] {
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
}

extension UserCollectionViewModel {
    var countUsers: Int {
        nfts.count
    }
    
    func nftCellViewModel(at index: Int) -> NftViewCellViewModel {
        let nft = nfts[index]
        // TODO: необходимо проверить ставил ли лайк наш профиль этому NFT
        return NftViewCellViewModel(nft: nft, isLiked: false)
    }
    
    func fetchNft() {
        guard let nftsId else { return }
        guard !nftsId.isEmpty else {
            showPlugView?(Consts.LocalizedStrings.plugLabelText)
            return
        }
        hideCollectionView?(true)
        nftsId.forEach({ [weak self] id in
            guard let self else { return }
            self.nftsProvider.fetchNft(id: id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    DispatchQueue.main.async {
                        self.nfts.append(nft)
                    }
                case .failure(let failure):
                    // TODO: show error alert6 or hide collection and show plugView
                    assertionFailure(failure.localizedDescription)
                }
            }
        })
    }
    
    func refreshNft() {
        nfts.removeAll()
        fetchNft()
    }
}
