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
    func nftCellViewModel(at index: Int) -> NftViewCellViewModel
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol, UserCollectionCoordination {
    var headForActionSheet: ((AlertModel) -> Void)?
    
    var showCollectionView: ((Bool) -> Void)?
    var showPlugView: ((Bool, String?) -> Void)?
    var showProgressHUD: ((Bool) -> Void)?
    var blockUI: ((Bool) -> Void)?
    
    private var nftsId: [String]?
    
    private var nfts: [NftNetworkModel] = [] {
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
        showProgressHUD?(true)
        guard let nftsId else { return }
        guard !nftsId.isEmpty else {
            showProgressHUD?(false)
            showPlugView?(true, Consts.LocalizedStrings.plugLabelText)
            return
        }
        showCollectionView?(false)
        nftsProvider.fetchNfts(nftsId: nftsId) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.nfts = model
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.showPlugView?(true, Consts.LocalizedStrings.statisticErrorPlugView)
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
        let alertModel = createErrorAlertModel(message: message)
        headForActionSheet?(alertModel)
    }
    
    func createErrorAlertModel(message: String) -> AlertModel {
        let alertText = Consts.LocalizedStrings.statisticErrorAlertTitle
        let alertRepeatActionText = Consts.LocalizedStrings.statisticErrorActionSheepNameRepeat
        let alertCancelText = Consts.LocalizedStrings.alertCancelText
        
        let alertRepeatAction = AlertAction(
            actionText: alertRepeatActionText,
            actionRole: .regular,
            action: { [weak self] in
                guard let self else { return }
                self.refreshNft()
            })
        
        let alertCancelAction = AlertAction(actionText: alertCancelText, actionRole: .cancel, action: nil)
        
        let alertModel = AlertModel(
            alertText: alertText,
            message: message,
            alertActions: [alertCancelAction, alertRepeatAction]
        )
        return alertModel
    }
}
