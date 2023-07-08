import UIKit

final class FinalPaymentView: CustomView {
    private let paymentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let termsOfUseStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular13
        label.textColor = Asset.Colors.ypBlack.color
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        return label
    }()
    
    private lazy var termsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.setTitleColor(Asset.Colors.ypBlueUniversal.color, for: .normal)
        button.addTarget(self, action: #selector(openTerms), for: .touchUpInside)
        return button
    }()
    
    private lazy var paymentButton: CustomButton = {
        let button = CustomButton(text: "Оплатить", height: 60)
        button.addTarget(
            self,
            action: #selector(paymentTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    weak var delegate: PaymentViewControllerDelegate?
    
    override init() {
        super.init()
        
        addElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func openTerms() {
        delegate?.openWebViewController()
    }
    
    @objc private func paymentTapped() {
        print("PAY")
    }
    
    private func addElements() {
        addSubview(paymentStackView)
        
        [
            termsOfUseStackView,
            paymentButton
            
        ].forEach { paymentStackView.addArrangedSubview($0) }
        
        [
            termsLabel,
            termsButton
        ].forEach { termsOfUseStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            paymentStackView.topAnchor.constraint(
                equalTo: topAnchor, constant: 16
            ),
            paymentStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16
            ),
            paymentStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16
            ),
            paymentStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -50
            )
        ])
    }
}
