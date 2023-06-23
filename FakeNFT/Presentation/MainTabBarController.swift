import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [ProfileNavController(),
                           CatalogueViewController(),
                           CartViewController(),
                           StatisticsViewController()]
        
        view.backgroundColor = .white
        tabBar.unselectedItemTintColor = Asset.Colors.ypBlack.color
        
    }
    
}
