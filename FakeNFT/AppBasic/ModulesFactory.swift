import Foundation

protocol ModulesFactoryProtocol {
    func makeStatisticView() -> (view: Presentable, coordination: StatisticCoordination)
    func makeUserCardView(userCardData: UserNetworkModel) -> (view: Presentable, coordination: UserCardCoordination)
    func makeUserCollection(nftsId: [String]?) -> (view: Presentable, coordination: UserCollectionCoordination)
    func makeAboutWebView(url: URL) -> Presentable
}

struct ModulesFactory {}

extension ModulesFactory: ModulesFactoryProtocol {
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
    
    func makeAboutWebView(url: URL) -> Presentable {
        let webViewViewModel = WebViewViewModel(url: url)
        let webViewController = WebViewViewController(viewModel: webViewViewModel)
        return webViewController
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
