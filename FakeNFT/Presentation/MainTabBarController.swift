import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [ProfileViewController(),
                           CatalogueViewController(viewModel: CatalogueViewModel()),
                           CartViewController(),
                           StatisticsViewController()]
        
        view.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
        
    }
    
}
