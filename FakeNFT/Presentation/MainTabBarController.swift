import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [ProfileViewController(),
                           getCatalogueNavigationController(),
                           CartViewController(),
                           StatisticsViewController()]
        
        view.backgroundColor = .white
        tabBar.unselectedItemTintColor = Asset.Colors.ypBlack.color
        
    }
    
    private func getCatalogueNavigationController() -> UINavigationController {
        let catalogueVM = CatalogueViewModel(networkClient: DefaultNetworkClient())
        let catalogueVC = CatalogueViewController(viewModel: catalogueVM)
        return UINavigationController(rootViewController: catalogueVC)
    }
}
