import UIKit

final class StarImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        self.image = Asset.Assets.star.image
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 12).isActive = true
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
