import UIKit

final class CartNavController: UINavigationController {
        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(title: Consts.LocalizedStrings.cart,
                                       image: Consts.Images.cart,
                                       tag: 2)
        
        view.backgroundColor = Asset.Colors.ypWhite.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
