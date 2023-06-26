import UIKit

final class StarImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        self.image = Asset.Assets.star.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
