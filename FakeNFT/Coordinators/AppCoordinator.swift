//
//  MainFlowCoordinator.swift
//  Tracker
//
//  Created by Aleksandr Velikanov on 01.04.2023.
//

protocol AppCoordinatorOutput {
    var finishFlow: (() -> Void)? { get set }
}

final class AppCoordinator: BaseCoordinator, Coordinatable, AppCoordinatorOutput {
    
    var finishFlow: (() -> Void)?
    
    private var coordinatorsFactory: CoordinatorsFactoryProtocol
    private var modulesFactory: ModulesFactoryProtocol
    private var router: Routable
    
    init(coordinatorsFactory: CoordinatorsFactoryProtocol, modulesFactory: ModulesFactoryProtocol, router: Routable) {
        self.coordinatorsFactory = coordinatorsFactory
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    func startFlow() {
        routeToTabBarController()
        createProfileFlow()
        createCatalogueFlow()
        createCartFlow()
        createStatisticsFlow()
    }
}

private extension AppCoordinator {
    func routeToTabBarController() {
        let tabBarController = MainTabBarController()
        router.setRootViewController(viewController: tabBarController)
    }
    
    func createProfileFlow() {
        
    }
    
    func createCatalogueFlow() {
       
    }
    
    func createCartFlow() {
        
    }
    
    func createStatisticsFlow() {
        let statisticCoordinator = coordinatorsFactory.makeStatisticsCoordinator(router: router)
        addDependency(statisticCoordinator)
        statisticCoordinator.startFlow()
    }
}
