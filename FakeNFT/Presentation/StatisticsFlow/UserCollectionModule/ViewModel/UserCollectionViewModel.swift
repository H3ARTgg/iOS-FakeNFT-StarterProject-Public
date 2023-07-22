import Foundation

protocol UserCollectionCoordination: AnyObject {
    var headForActionSheet: ((AlertModel) -> Void)? { get set }
}

protocol UserCollectionViewModelProtocol {
    var showCollectionView: ((Bool) -> Void)? { get set }
    var showPlugView: ((Bool, String?) -> Void)? { get set }
    var showProgressHUD: ((Bool) -> Void)? { get set }
    
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
    private var favoriteNFT: [String] = [] {
        didSet {
            showCollectionView?(isDownload)
        }
    }
    
    private var nfts: [NftResponseModel] = [] {
        didSet {
            showCollectionView?(isDownload)
        }
    }
    
    private let nftsProvider: NftProviderProtocol
    private let errorHandler: ErrorHandlerProtocol

    private var isDownload: Bool {
        guard nftsId != nil else { return true }
        return !favoriteNFT.isEmpty && !nfts.isEmpty
    }
    
    init(
        nftsId: [String]?,
        nftsProvider: NftProviderProtocol,
        errorHandler: ErrorHandlerProtocol ) {
            self.nftsProvider = nftsProvider
            self.nftsId = nftsId
            self.errorHandler = errorHandler
            fetchFavoriteNFT()
        }
}

extension UserCollectionViewModel {
    var countUsers: Int {
        nfts.count
    }
    
    func nftCellViewModel(at index: Int) -> NftViewCellViewModel? {
        guard !nfts.isEmpty else { return nil }
        let nft = nfts[index]
        let isLiked = favoriteNFT.contains(nfts[index].id )
        let viewModel = NftViewCellViewModel(nft: nft, isLiked: isLiked)
        viewModel.delegate = self
        return viewModel
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
                let nfts = model.sorted {
                    $0.id < $1.id
                }
                DispatchQueue.main.async {
                    self.nfts = nfts
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
        fetchFavoriteNFT()
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

    private func fetchFavoriteNFT() {
        nftsProvider.fetchFavoriteNFT { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.favoriteNFT = model
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
}

extension UserCollectionViewModel: NftViewCellViewModelDelegate {
    func changeFavoritesForNFT(id: String) {
        showProgressHUD?(true)

        if let index = favoriteNFT.firstIndex(of: id) {
            favoriteNFT.remove(at: index)
        } else {
            favoriteNFT.append(id)
        }

        nftsProvider.changeFavoritesForNFT(favoriteNFT: favoriteNFT) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.fetchFavoriteNFT()
                DispatchQueue.main.async {
                    self.showProgressHUD?(false)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showProgressHUD?(false)
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
}
