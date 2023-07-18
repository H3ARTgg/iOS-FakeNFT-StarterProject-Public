import Foundation

final class StatisticsCoordinator: BaseCoordinator, Coordinatable {
    var finishFlow: (() -> Void)?
    
    private var modulesFactory: ModulesFactoryProtocol
    private var router: Routable
    private let navController = StatisticNavController()
    
    init(modulesFactory: ModulesFactoryProtocol, router: Routable) {
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    func startFlow() {
        router.addToTabBar(navController)
        performFlow()
    }
}

private extension StatisticsCoordinator {
    func performFlow() {
        let statisticModule = modulesFactory.makeStatisticView()
        let statisticView  = statisticModule.view
        let statisticCoordination = statisticModule.coordination
        
        statisticCoordination.headForActionSheet = { [weak self] alertModel in
            guard let self else { return }
            self.router.presentAlertController(alertModel: alertModel, preferredStyle: .actionSheet)
        }
        
        statisticCoordination.headForAlert = { [weak self] alertModel in
            guard let self else { return }
            self.router.presentAlertController(alertModel: alertModel, preferredStyle: .alert)
        }
        
        statisticCoordination.headForUserCard = { [weak self] userCard in
            guard let self else { return }
            let userCardModule = self.modulesFactory.makeUserCardView(userCardData: userCard)
            let userCardView = userCardModule.view
            var userCardCoordination = userCardModule.coordination
            
            userCardCoordination.headForAbout = { [weak self] userURL in
                guard let self else { return }
                let aboutView = self.modulesFactory.makeAboutWebView(urlString: userURL)
                self.router.push(aboutView, to: navController)
            }
            
            userCardCoordination.headForUserCollection = { [weak self] nftId in
                guard let self else { return }
                let userCollectionModule = self.modulesFactory.makeUserCollection(nftsId: nftId)
                let userCollectionView = userCollectionModule.view
                let userCollectionCoordination = userCollectionModule.coordination
                
                userCollectionCoordination.headForActionSheet = { [weak self] alertModel in
                    guard let self else { return }
                    self.router.presentAlertController(alertModel: alertModel, preferredStyle: .alert)
                }
                
                self.router.push(userCollectionView, to: navController)
            }
            self.router.push(userCardView, to: navController)
        }
        
        self.router.push(statisticView, to: navController)
    }
}
