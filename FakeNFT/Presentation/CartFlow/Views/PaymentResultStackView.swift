import UIKit

final class PaymentResultStackView: UIStackView {
    private let placeholderImageView: UIImageView = {
         let view = UIImageView()
         view.contentMode = .scaleAspectFit
         return view
     }()
     
     private let placeholderLabel: UILabel = {
         let label = UILabel()
         label.font = Consts.Fonts.bold22
         label.textColor = Asset.Colors.ypBlack.color
         label.textAlignment = .center
         label.numberOfLines = 0
         return label
     }()
    
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
    
    init() {
        super.init(frame: .zero)
        
        setupPlaceholders()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlaceholders() {
        axis = .vertical
        distribution = .fill
        alignment = .fill
        spacing = 20
        translatesAutoresizingMaskIntoConstraints = false
        
        [
            placeholderImageView,
            placeholderLabel
        ].forEach { addArrangedSubview($0) }
        
        placeholderImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        placeholderLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func configure(_ image: UIImage, _ textLabel: String) {
        paymentResultImageView.image = image
        paymentResultLabel.text = textLabel
        
        replaceElements()
    }
    
    private func addElements() {
        [
            paymentResultImageView,
            paymentResultLabel
        ].forEach { addArrangedSubview($0) }
    }
    
    private func replaceElements() {
        removeArrangedSubview(placeholderImageView)
        removeArrangedSubview(placeholderLabel)
        
        placeholderImageView.removeFromSuperview()
        placeholderLabel.removeFromSuperview()
        
        addElements()
    }
}
