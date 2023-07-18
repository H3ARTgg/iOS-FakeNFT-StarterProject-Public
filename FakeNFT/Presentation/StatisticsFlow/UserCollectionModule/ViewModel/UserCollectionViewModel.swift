import Foundation

protocol UserCollectionCoordination: AnyObject {
    var headForActionSheet: ((AlertModel) -> Void)? { get set }
}

protocol UserCollectionViewModelProtocol {
    var showCollectionView: ((Bool) -> Void)? { get set }
    var showPlugView: ((Bool, String?) -> Void)? { get set }
    var showProgressHUD: ((Bool) -> Void)? { get set }
    var blockUI: ((Bool) -> Void)? { get set }
    
    var countUsers: Int { get }
    
    func fetchNft()
    func refreshNft()
    func nftCellViewModel(at index: Int) -> NftViewCellViewModel?
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol, UserCollectionCoordination {
    var headForActionSheet: ((AlertModel) -> Void)?
    
    var showCollectionView: ((Bool) -> Void)?
    var showPlugView: ((Bool, String?) -> Void)?
    var showProgressHUD: ((Bool) -> Void)?
    var blockUI: ((Bool) -> Void)?
    
    private var nftsId: [String]?
    
    private var nfts: [NftResponseModel] = [] {
        didSet {
            guard let nftsId
            else {
                showCollectionView?(true)
                return
            }
            if nfts.count == nftsId.count {
                showCollectionView?(true)
            }
        }
    }
    
    private let nftsProvider: NftProviderProtocol
    private let errorHandler: ErrorHandlerProtocol
    
    init(
        nftsId: [String]?,
        nftsProvider: NftProviderProtocol,
        errorHandler: ErrorHandlerProtocol ) {
            self.nftsProvider = nftsProvider
            self.nftsId = nftsId
            self.errorHandler = errorHandler
        }
}

extension UserCollectionViewModel {
    var countUsers: Int {
        nfts.count
    }
    
    func nftCellViewModel(at index: Int) -> NftViewCellViewModel? {
        guard !nfts.isEmpty else { return nil }
        let nft = nfts[index]
        // TODO: необходимо проверить ставил ли лайк наш профиль этому NFT
        return NftViewCellViewModel(nft: nft, isLiked: false)
    }
    
    func fetchNft() {
        showProgressHUD?(true)
        guard let nftsId else { return }
        guard !nftsId.isEmpty else {
            showProgressHUD?(false)
            showPlugView?(true, L10n.Statistic.PlugLabel.text)
            return
        }
        showCollectionView?(false)
        nftsProvider.fetchNfts(nftsId: nftsId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.nfts = model
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.showPlugView?(true, L10n.Statistic.ErrorPlugView.text)
                    self.showErrorAlert(message: failure.localizedDescription)
                }
            }
            self.showProgressHUD?(false)
            self.blockUI?(false)
        }
    }
    
    func refreshNft() {
        blockUI?(true)
        nfts.removeAll()
        fetchNft()
    }
    
    func showErrorAlert(message: String) {
        let alertModel = errorHandler.createErrorAlertModel(
            message: message) { [ weak self] in
                guard let self else { return }
                self.refreshNft()
            }
        headForActionSheet?(alertModel)
    }
}
