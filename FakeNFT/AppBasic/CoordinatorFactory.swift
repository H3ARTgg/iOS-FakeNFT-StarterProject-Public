//
//  CoordinatorFactory.swift
//  Tracker
//
//  Created by Aleksandr Velikanov on 01.04.2023.
//

protocol CoordinatorsFactoryProtocol {
    func makeAppCoordinator(router: Routable) -> Coordinatable & AppCoordinatorOutput
    func makeProfileCoordinator(router: Routable) -> Coordinatable
    func makeCatalogueCoordinator(router: Routable) -> Coordinatable
    func makeCartCoordinator(router: Routable) -> Coordinatable
    func makeStatisticsCoordinator(router: Routable) -> Coordinatable
    
}

final class CoordinatorFactory {
    private let modulesFactory: ModulesFactoryProtocol = ModulesFactory()
}

extension CoordinatorFactory: CoordinatorsFactoryProtocol {
    func makeAppCoordinator(router: Routable) -> Coordinatable & AppCoordinatorOutput {
        return AppCoordinator(coordinatorsFactory: self,
                              modulesFactory: modulesFactory,
                              router: router)
    }
    
    func makeProfileCoordinator(router: Routable) -> Coordinatable {
        ProfileCoordinator(modulesFactory: modulesFactory, router: router)
    }
    
    func makeCatalogueCoordinator(router: Routable) -> Coordinatable {
        CartCoordinator(modulesFactory: modulesFactory, router: router)
    }
    
    func makeCartCoordinator(router: Routable) -> Coordinatable {
        CartCoordinator(modulesFactory: modulesFactory, router: router)
    }
    
    func makeStatisticsCoordinator(router: Routable) -> Coordinatable {
        StatisticsCoordinator(modulesFactory: modulesFactory, router: router)
    }
}
