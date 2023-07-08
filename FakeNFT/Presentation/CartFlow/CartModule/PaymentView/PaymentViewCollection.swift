import UIKit

final class PaymentViewCollection: UIView {
    
    private let paymentView = FinalPaymentView()
    
    weak var delegate: PaymentViewControllerDelegate?
    
    func configure(delegate: PaymentViewController) {
        backgroundColor = Asset.Colors.ypWhite.color
        
        self.delegate = delegate
        paymentView.delegate = self.delegate
        
        addElements()
        setupConstraints()
    }
    
    private func addElements() {
        addSubview(paymentView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            paymentView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            paymentView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            paymentView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            )
        ])
    }
}
