import Foundation

final class CartCoordinator: BaseCoordinator, Coordinatable {
    var finishFlow: (() -> Void)?
    
    private var modulesFactory: ModulesFactoryProtocol
    private var router: Routable
    private let navController = CartNavController()
    
    init(modulesFactory: ModulesFactoryProtocol, router: Routable) {
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    func startFlow() {
        router.addToTabBar(navController)
        performFlow()
    }
}

private extension CartCoordinator {
    func performFlow() {
        let cartModule = modulesFactory.makeCartView()
        let cartModuleView = cartModule.view
        let cartCoordinator = cartModule.coordination
        
        cartCoordinator.handleForActionSheet = { [weak self] alertModel in
            self?.router.presentAlertController(alertModel: alertModel, preferredStyle: .actionSheet)
        }
        
        cartCoordinator.handleForErrorAlert = { [weak self] alertModel in
            self?.router.presentAlertController(alertModel: alertModel, preferredStyle: .alert)
        }
                
        cartCoordinator.handleNftSelection = { [weak self] nft, cartViewModel in
            guard let self else {
                return
            }
            
            let deleteNftModule = self.modulesFactory.makeDeleteNftView(nft: nft, cartViewModel: cartViewModel)
            let deleteNftView = deleteNftModule.view
            let deleteNftCoordinator = deleteNftModule.coordination
            router.present(deleteNftView, presentationStyle: .custom)
            
            deleteNftCoordinator.handleNftDeletion = { [weak self] in
                self?.router.dismissModule(deleteNftView)
            }
        }
        
        cartCoordinator.handlePaymentScreenOpening = { [weak self] cartViewModel in
            guard let self else {
                return
            }
            
            let paymentModule = modulesFactory.makePaymentView(cartViewModel: cartViewModel)
            let paymentView = paymentModule.view
            let paymentCoordinator = paymentModule.coordination
            self.router.push(paymentView, to: navController)
            
            paymentCoordinator.handleForAlert = { [weak self] alertModel in
                self?.router.presentAlertController(alertModel: alertModel, preferredStyle: .alert)
            }
            
            paymentCoordinator.handleTermsScreenOpening = { [weak self] in
                guard let self else {
                    return
                }
                
                let aboutView = self.modulesFactory.makeAboutWebView(urlString: Consts.Cart.Url.termsUrl)
                router.push(aboutView, to: navController)
            }
            
            paymentCoordinator.handlePaymentResultScreenPresentation = { [weak self] state in
                guard let self else {
                    return
                }
                
                let resultPaymentModule = modulesFactory.makePaymentResultView(state, cartViewModel)
                let resultPaymentView = resultPaymentModule.view
                let resultPaymentCoordinator = resultPaymentModule.coordination
                
                resultPaymentCoordinator.handleCartScreenReturn = { [weak self] in
                    self?.router.popToRoot(animated: true)
                }
                
                router.push(resultPaymentView, to: navController)
            }
            
            paymentCoordinator.handleCartScreenReturn = { [weak self] in
                self?.router.pop()
            }
            
        }
        
        router.push(cartModuleView, to: navController)
    }
}
