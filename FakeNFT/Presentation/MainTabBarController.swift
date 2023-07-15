import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = []
        
        view.backgroundColor = .white
        tabBar.unselectedItemTintColor = Asset.Colors.ypBlack.color
        
    }
    
}
