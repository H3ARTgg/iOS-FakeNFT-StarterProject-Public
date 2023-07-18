import Foundation

final class CatalogueCoordinator: BaseCoordinator, Coordinatable {
    var finishFlow: (() -> Void)?
    
    private var modulesFactory: ModulesFactoryProtocol
    private var router: Routable
    private let navController = CatalogueNavController()
    
    init(modulesFactory: ModulesFactoryProtocol, router: Routable) {
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    func startFlow() {
        router.addToTabBar(navController)
        performFlow()
    }
}

private extension CatalogueCoordinator {
    func performFlow() {
        let catalogueModule = modulesFactory.makeCatalogueView()
        let catalogueCoordination = catalogueModule.coordination
        let catalogueView = catalogueModule.view
        
        catalogueCoordination.headForActionSheet = {[weak self] alertModel in
            self?.router.presentActionSheet(alertModel: alertModel)
        }
        
        catalogueCoordination.headForCollectionDetails = { [weak self] collectionId in
            guard let self else { return }
            let collectionDetailsModule = self.modulesFactory.makeCollectionDetailsViewWith(collectionId: collectionId)
            let collectionDetailsCoordination = collectionDetailsModule.coordination
            let collectionDetailsView = collectionDetailsModule.view
            
            collectionDetailsCoordination.finish = {
                self.router.popToRoot(animated: true)
            }
            
            collectionDetailsCoordination.headForAbout = { urlString in
                let webView = self.modulesFactory.makeAboutWebView(urlString: urlString)
                self.router.push(webView, to: self.navController)
            }
            
            self.router.push(collectionDetailsView, to: self.navController)
        }
        
        router.push(catalogueView, to: navController)
    }
}
