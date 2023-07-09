//
//  CartCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 09.07.2023.
//

import Foundation

final class CartCoordinator: BaseCoordinator, Coordinatable {
    var finishFlow: (() -> Void)?
    
    private var modulesFactory: ModulesFactoryProtocol
    private var router: Routable
    
    init(modulesFactory: ModulesFactoryProtocol, router: Routable) {
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    func startFlow() {
        performFlow()
    }
}

private extension CartCoordinator {
    func performFlow() {
        
    }
}
