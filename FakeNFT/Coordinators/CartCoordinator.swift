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
        router.addToTabBar(CartNavController())
        performFlow()
    }
}

private extension CartCoordinator {
    func performFlow() {
        let cartModule = modulesFactory.makeCartView()
        let cartModuleView = cartModule.view
        let cartCoordinator = cartModule.coordination
        
        cartCoordinator.handleForActionSheet = { [weak self] alertModel in
            guard let self else { return }
            self.router.presentAlertController(alertModel: alertModel, preferredStyle: .actionSheet)
        }
                
        cartCoordinator.handleNftSelection = { [weak self] nft, cartViewModel in
            guard let self else { return }
            
            let deleteNftModule = self.modulesFactory.makeDeleteNftView(nft: nft, cartViewModel: cartViewModel)
            let deleteNftView = deleteNftModule.view
            let deleteNftCoordinator = deleteNftModule.coordination
            self.router.present(deleteNftView, presentationStyle: .custom)
            
            deleteNftCoordinator.handleNftDeletion = {
                self.router.dismissModule(deleteNftView)
            }
        }
        
        cartCoordinator.handlePaymentScreenOpening = { cartViewModel in
            
            let paymentModule = self.modulesFactory.makePaymentView(cartViewModel: cartViewModel)
            let paymentView = paymentModule.view
            let paymentCoordinator = paymentModule.coordination
            self.router.push(paymentView, animated: true)
            
            paymentCoordinator.handleForAlert = { [weak self] alertModel in
                guard let self else { return }
                self.router.presentAlertController(alertModel: alertModel, preferredStyle: .alert)
            }
            
            paymentCoordinator.handleTermsScreenOpening = { [weak self] userURL in
                guard let self else { return }
                let aboutView = self.modulesFactory.makeAboutWebView(url: userURL)
                self.router.push(aboutView)
            }
            
            paymentCoordinator.handlePaymentResultScreenPresentation = { [weak self] state in
                guard let self else { return }
                let resultPaymentModule = self.modulesFactory.makePaymentResultView(state, cartViewModel)
                let resultPaymentView = resultPaymentModule.view
                let resultPaymentCoordinator = resultPaymentModule.coordination
                
                resultPaymentCoordinator.handleCartScreenReturn = {
                    self.router.popToRoot(animated: true)
                }
                
                self.router.push(resultPaymentView)
            }
            
            paymentCoordinator.handleCartScreenReturn = { [weak self] in
                guard let self else { return }
                self.router.pop()
            }
            
        }
        
        router.push(cartModuleView)
    }
}
