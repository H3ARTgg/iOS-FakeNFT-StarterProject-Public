import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [ProfileViewController(),
                           CatalogueViewController(viewModel: CatalogueViewModel(networkClient: DefaultNetworkClient())),
                           CartViewController(),
                           StatisticsViewController()]
        
        view.backgroundColor = .white
        tabBar.unselectedItemTintColor = Asset.Colors.ypBlack.color
        
    }
    
}
