import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [ProfileViewController(),
                           CatalogueViewController(),
                           UINavigationController(rootViewController: CartViewController()),
                           StatisticsViewController()]
        
        view.backgroundColor = .white
        tabBar.unselectedItemTintColor = Asset.Colors.ypBlack.color
        
    }
    
}
