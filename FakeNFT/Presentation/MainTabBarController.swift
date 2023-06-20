import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [ProfileViewController(),
                           CatalogueViewController(),
                           CartViewController(),
                           creatRatingViewController()]
        
        view.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
    }
}

extension MainTabBarController {
    func creatRatingViewController() -> UINavigationController {
        let viewController = RatingViewController()
        viewController.tabBarItem = UITabBarItem(
            title: Consts.LocalizedStrings.statistics,
            image: Consts.Images.statistics,
            tag: 3)
        return UINavigationController(rootViewController: viewController)
    }
}
