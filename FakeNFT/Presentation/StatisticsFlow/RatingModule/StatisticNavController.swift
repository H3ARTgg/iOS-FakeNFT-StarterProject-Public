import UIKit

final class StatisticNavController: UINavigationController {
        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(
            title: Consts.LocalizedStrings.statistics,
            image: Consts.Images.statistics,
            tag: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
