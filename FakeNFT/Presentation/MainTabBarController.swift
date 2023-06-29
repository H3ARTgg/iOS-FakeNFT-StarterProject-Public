import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let catalogueVM = CatalogueViewModel(networkClient: DefaultNetworkClient())
        let catalogueVC = CatalogueViewController(viewModel: catalogueVM)
        let catalogueNavCon = UINavigationController(rootViewController: catalogueVC)
        viewControllers = [ProfileViewController(),
                           catalogueNavCon,
                           CartViewController(),
                           StatisticsViewController()]
        
        view.backgroundColor = .white
        tabBar.unselectedItemTintColor = Asset.Colors.ypBlack.color
        
    }
    
}
