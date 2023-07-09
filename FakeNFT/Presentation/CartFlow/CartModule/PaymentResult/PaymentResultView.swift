import UIKit

protocol PaymentResultViewDelegate: AnyObject {
    func updateUi(_ image: UIImage, _ text: String, _ textButton: String)
}

final class PaymentResultView: UIView {
    
    private let paymentResultStackView = PaymentResultStackView()
    private let paymentResultButton = CustomButton(text: "", height: 60)
    
    func configure() {
        backgroundColor = Asset.Colors.ypWhite.color
                
        addElements()
        setupConstraints()
    }
    
    private func addElements() {
        [
            paymentResultStackView,
            paymentResultButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            paymentResultStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 26
            ),
            paymentResultStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -26
            ),
            paymentResultStackView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            
            paymentResultButton.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16
            ),
            paymentResultButton.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16
            ),
            paymentResultButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16
            )
        ])
    }
}

extension PaymentResultView: PaymentResultViewDelegate {
    func updateUi(_ image: UIImage, _ textLabel: String, _ textButton: String) {
        paymentResultStackView.configure(image, textLabel)
        paymentResultButton.setTitle(textButton, for: .normal)
    }
}
