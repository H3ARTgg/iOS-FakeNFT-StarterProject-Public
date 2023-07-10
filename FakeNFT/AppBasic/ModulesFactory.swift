import Foundation

protocol ModulesFactoryProtocol {
    func makeStatisticView() -> (view: Presentable, coordination: StatisticCoordination)
    func makeUserCardView(userCardData: UserNetworkModel) -> (view: Presentable, coordination: UserCardCoordination)
    func makeUserCollection(nftsId: [String]?) -> Presentable
    func makeAboutWebView(url: URL) -> Presentable
}

struct ModulesFactory {}

extension ModulesFactory: ModulesFactoryProtocol {
    func makeStatisticView() -> (view: Presentable, coordination: StatisticCoordination) {
        let statisticProvider = StatisticProvider()
        let sortStore = SortingStore()
        let statisticViewModel = RatingViewModel(statisticProvider: statisticProvider, sortStore: sortStore)
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
    
    func makeUserCollection(nftsId: [String]?) -> Presentable {
        let nftsProvider = NftProvider()
        let userCollectionViewModel = UserCollectionViewModel(nftsId: nftsId, nftsProvider: nftsProvider)
        let userCollectionViewController = UserCollectionViewController(viewModel: userCollectionViewModel)
        return userCollectionViewController
    }
}
