import Foundation

protocol ModulesFactoryProtocol {
    func makeProfileView() -> (view: Presentable, coordination: ProfileCoordination)
    func makeProfileEditView(profileData: ProfileUserViewModel) -> (view: Presentable, coordination: ProfileEditCoordination)
    func makeOwnedNftView(ownedNfts: [String]) -> (view: Presentable, coordination: OwnedNftCoordination)
    func makeFavoriteNftView(favoriteNfts: [String]) -> (view: Presentable, coordination: FavoriteNftCoordination)
    func makeAboutWebView(urlString: String) -> Presentable
    func makeCartView() -> (view: Presentable, coordination: CartCoordination)
    func makeDeleteNftView(nft: Nft?, cartViewModel: CartViewModel) -> (view: Presentable, coordination: CartCoordination)
    func makePaymentView(cartViewModel: CartViewModel) -> (view: Presentable, coordination: PaymentCoordination)
    func makePaymentResultView(_ state: ViewState, _ cartViewModel: CartViewModel) -> (view: Presentable, coordination: CartCoordination)
    
    func makeStatisticView() -> (view: Presentable, coordination: StatisticCoordination)
    func makeUserCardView(userCardData: UserNetworkModel) -> (view: Presentable, coordination: UserCardCoordination)
    func makeUserCollection(nftsId: [String]?) -> (view: Presentable, coordination: UserCollectionCoordination)
}

final class ModulesFactory: ModulesFactoryProtocol {
    let networkManager: NftDataManagerProtocol = NftDataManager(networkService: DefaultNetworkClient())
    let cartNetworkService: CartNetworkServiceProtocol = CartNetworkService(networkClient: DefaultNetworkClient())
    let paymentNetworkService: PaymentNetworkServiceProtocol = PaymentNetworkService(networkClient: DefaultNetworkClient())
}

// MARK: - Profile Flow

extension ModulesFactory {
    func makeProfileView() -> (view: Presentable, coordination: ProfileCoordination) {
        let profileViewModel = ProfileViewModel(networkManager: networkManager)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        return (profileViewController, profileViewModel)
    }
    
    func makeProfileEditView(profileData: ProfileUserViewModel) -> (view: Presentable, coordination: ProfileEditCoordination) {
        let profileEditViewModel = ProfileEditViewModel(profile: profileData)
        let profileEditViewController = ProfileEditTableView(viewModel: profileEditViewModel)
        return (profileEditViewController, profileEditViewModel)
    }
    
    func makeOwnedNftView(ownedNfts: [String]) -> (view: Presentable, coordination: OwnedNftCoordination) {
        let ownedNftViewModel = OwnedNftViewModel(networkManager: networkManager, ownedNfts: ownedNfts)
        let ownedNftViewController = OwnedNftViewController(viewModel: ownedNftViewModel)
        return (ownedNftViewController, ownedNftViewModel)
    }
    
    func makeFavoriteNftView(favoriteNfts: [String]) -> (view: Presentable, coordination: FavoriteNftCoordination) {
        let favoriteNftViewModel = FavoriteNftViewModel(networkManager: networkManager, favoriteNfts: favoriteNfts)
        let favoriteNftViewController = FavoriteNftViewController(viewModel: favoriteNftViewModel)
        return (favoriteNftViewController, favoriteNftViewModel)
    }
    
    func makeAboutWebView(urlString: String) -> Presentable {
        let url = URL(string: urlString)
        let webViewViewModel = WebViewViewModel(url: url)
        let webViewController = WebViewViewController(viewModel: webViewViewModel)
        return webViewController
    }
}

// MARK: - Cart Flow

extension ModulesFactory {
    func makeCartView() -> (view: Presentable, coordination: CartCoordination) {
        let cartViewModel = CartViewModel(cartNetworkService: cartNetworkService)
        let cartViewController = CartViewController(cartViewModel: cartViewModel)
        return (cartViewController, cartViewModel)
    }
    
    func makeDeleteNftView(nft: Nft?, cartViewModel: CartViewModel) -> (view: Presentable, coordination: CartCoordination) {
        let deleteNftViewController = DeleteNftViewController(cartViewModel: cartViewModel)
        deleteNftViewController.nft = nft
        return (deleteNftViewController, cartViewModel)
    }
    
    func makePaymentView(cartViewModel: CartViewModel) -> (view: Presentable, coordination: PaymentCoordination) {
        let paymentViewModel = PaymentViewModel(paymentNetworkService: paymentNetworkService)
        let paymentViewController = PaymentViewController(cartViewModel: cartViewModel, paymentViewModel: paymentViewModel)
        return (paymentViewController, paymentViewModel)
    }
    
    func makePaymentResultView(_ state: ViewState, _ cartViewModel: CartViewModel) -> (view: Presentable, coordination: CartCoordination) {
        let paymentResultViewController = PaymentResultViewController(cartViewModel: cartViewModel)
        paymentResultViewController.state = state
        return (paymentResultViewController, cartViewModel)
    }
}

// MARK: - Statistic Flow
extension ModulesFactory {
    func makeStatisticView() -> (view: Presentable, coordination: StatisticCoordination) {
        let statisticProvider = StatisticProvider()
        let sortStore = SortingStore()
        let errorHandler = ErrorHandler()
        let statisticViewModel = RatingViewModel(
            statisticProvider: statisticProvider,
            sortStore: sortStore,
            errorHandler: errorHandler
        )
        let statisticViewController = RatingViewController(viewModel: statisticViewModel)
        return (statisticViewController, statisticViewModel)
    }
    
    func makeUserCardView(userCardData: UserNetworkModel) -> (view: Presentable, coordination: UserCardCoordination) {
        let userCardViewModel = UserCardViewModel(user: userCardData)
        let userCardViewController = UserCardViewController(viewModel: userCardViewModel)
        return (userCardViewController, userCardViewModel)
    }
    
    
    func makeUserCollection(nftsId: [String]?) -> (view: Presentable, coordination: UserCollectionCoordination) {
        let nftsProvider = NftProvider()
        let errorHandler = ErrorHandler()
        let userCollectionViewModel = UserCollectionViewModel(
            nftsId: nftsId,
            nftsProvider: nftsProvider,
            errorHandler: errorHandler
        )
        let userCollectionViewController = UserCollectionViewController(viewModel: userCollectionViewModel)
        
        return (userCollectionViewController, userCollectionViewModel)
    }
}
