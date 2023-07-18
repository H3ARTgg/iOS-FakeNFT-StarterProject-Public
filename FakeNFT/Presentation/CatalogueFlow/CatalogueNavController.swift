import UIKit

final class CatalogueNavController: UINavigationController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(title: L10n.Catalogue.icon,
                                  image: Consts.Images.catalogue,
                                  tag: 1)
        view.backgroundColor = Asset.Colors.ypWhite.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
