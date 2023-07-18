import UIKit

final class CustomButton: UIButton {
    func configure(text: String, height: CGFloat? = nil) {
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.bodyBold
        setTitleColor(Asset.Colors.ypWhite.color, for: .normal)
        backgroundColor = Asset.Colors.ypBlack.color
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height ?? 44).isActive = true
        layer.cornerRadius = 16
    }
}
