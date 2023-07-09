import UIKit

final class PaymentResultStackView: UIStackView {
    private let paymentResultImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let paymentResultLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold22
        label.textColor = Asset.Colors.ypBlack.color
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    func configure(_ image: UIImage, textLabel: String) {
        axis = .vertical
        distribution = .fill
        alignment = .fill
        spacing = 20
        translatesAutoresizingMaskIntoConstraints = false
                
        addElements()
        
        paymentResultImageView.image = image
        paymentResultLabel.text = textLabel
    }
    
    private func addElements() {
        [
            paymentResultImageView,
            paymentResultLabel
        ].forEach { addArrangedSubview($0) }
    }
}
