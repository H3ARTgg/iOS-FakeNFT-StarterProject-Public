import UIKit

final class CustomButton: UIButton {
    init(text: String) {
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.bodyBold
        titleLabel?.textColor = UIColor(asset: Asset.Colors.ypWhite)
        backgroundColor = UIColor(asset: Asset.Colors.ypBlack)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Consts.Cart.heightButton).isActive = true
        layer.cornerRadius = Consts.Cart.buttonRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
