import UIKit

final class StarImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        self.image = UIImage(asset: Asset.Assets.star)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Consts.Cart.heightStarImage).isActive = true
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
