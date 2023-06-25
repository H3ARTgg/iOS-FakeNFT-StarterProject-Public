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
        label.font = UIFont.caption1
        label.text = "0 NFT"
        label.textColor = UIColor(asset: Asset.Colors.ypBlack)
        return label
    }()
    
    private let totalSumProducts: CustomLabel = {
        let label = CustomLabel(text: "00,00 ETH")
        label.textColor = UIColor(asset: Asset.Colors.ypGreenUniversal)
        return label
    }()
    
    private lazy var paymentButton: CustomButton = {
        let button = CustomButton(text: "К оплате")
        button.addTarget(
            self,
            action: #selector(paymentTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    weak var delegate: CartViewControllerDelegate?
    
    init(delegate: CartViewControllerDelegate) {
        super.init()
        self.delegate = delegate
        
        addElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshData() {
        setupQuantityNfts()
        setupTotalPrice()
    }
    
    @objc private func paymentTapped() {
        delegate?.openPaymentViewController()
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
    
    private func setupQuantityNfts() {
        let count = delegate?.getQuantityNfts() ?? 0
        numbersProducts.text = "\(count) NFT"
        
    }
    
    private func setupTotalPrice() {
        let totalPrice = delegate?.getTotalPrice() ?? 0
        totalSumProducts.text = (String(format: "%.2f", totalPrice) + " ETH").replacingOccurrences(of: ".", with: ",")
    }
}
