import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        tabBar.unselectedItemTintColor = Asset.Colors.ypBlack.color
    }
}
