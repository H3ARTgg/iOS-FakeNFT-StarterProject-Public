import UIKit

class CustomView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(asset: Asset.Colors.ypLightGray)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = Consts.Cart.paymentViewRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
