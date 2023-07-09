import UIKit

final class PaymentResultView: UIView {
    
    private let paymentResultStackView = PaymentResultStackView()
    private let paymentResultButton = CustomButton(text: "", height: 60)
    
    func configure() {
        backgroundColor = Asset.Colors.ypWhite.color
        
        addElements()
        setupConstraints()
        
        paymentResultStackView.configure(
            Asset.Assets.failResult.image,
            textLabel:
                        """
                        Упс! Что-то пошло не так :(
                        Попробуйте ещё раз!
                        """
        )
        paymentResultButton.setTitle("Попробовать еще раз", for: .normal)
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
                equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16
            ),
            paymentResultStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16
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
