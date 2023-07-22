import UIKit

final class StatisticNavController: UINavigationController {
        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(
            title: L10n.Statistics.icon,
            image: Asset.Assets.flag2CrossedFill.image,
            tag: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
