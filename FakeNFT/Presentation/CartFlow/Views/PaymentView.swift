import UIKit

final class PaymentView: CustomView {
    
    private let paymentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let totalSumStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 2
        return stack
    }()
    
    private let numbersProducts: UILabel = {
        let label = UILabel()
        label.text = "3 NFT"
        label.font = UIFont.caption1
        label.textColor = UIColor(asset: Asset.Colors.ypBlack)
        return label
    }()
    
    private let totalSumProducts: CustomLabel = {
        let label = CustomLabel(text: "5,34 ETH")
        label.textColor = UIColor(asset: Asset.Colors.ypGreenUniversal)
        return label
    }()
    
    private let paymentButton = CustomButton(text: "К оплате")
    
    override init() {
        super.init()
        
        addElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addElements() {
        [
            paymentStackView,
            paymentButton
        ].forEach { addSubview($0) }
        
        [
            totalSumStackView,
            paymentButton
        ].forEach { paymentStackView.addArrangedSubview($0) }
        
        [
            numbersProducts,
            totalSumProducts
        ].forEach { totalSumStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            paymentStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16
            ),
            paymentStackView.topAnchor.constraint(
                equalTo: topAnchor, constant: 16
            ),
            paymentStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16
            ),
            paymentStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -16
            )
        ])
    }
}
