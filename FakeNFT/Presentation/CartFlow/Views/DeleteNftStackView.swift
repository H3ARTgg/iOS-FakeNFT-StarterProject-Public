import UIKit

final class DeleteNftStackView: UIStackView {
    
    // MARK: - Properties
    private let messageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private let defaultImageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.Assets.nftCard.image
        view.contentMode = .center
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = Consts.LocalizedStrings.cartDeleteMessage
        label.font = UIFont.caption2
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = Asset.Colors.ypBlack.color
        return label
    }()
    
    private lazy var deleteButton: CustomButton = {
        let button = CustomButton(text: Consts.LocalizedStrings.cartDeleteButton)
        button.titleLabel?.font = UIFont.bodyRegular
        button.setTitleColor(Asset.Colors.ypRedUniversal.color, for: .normal)
        button.addTarget(
            self,
            action: #selector(deleteNft),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var cancelButton: CustomButton = {
        let button = CustomButton(text: Consts.LocalizedStrings.cartCancelButton)
        button.titleLabel?.font = UIFont.bodyRegular
        button.addTarget(
            self,
            action: #selector(cancel),
            for: .touchUpInside
        )
        return button
    }()
    
    weak var delegate: DeleteNftViewControllerDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
        addElements()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func deleteNft() {
        delegate?.deleteNft()
    }
    
    @objc private func cancel() {
        delegate?.closeViewController()
    }
    
    private func config() {
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = 20
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Private methods
    private func addElements() {
        [
            messageStackView,
            buttonStackView
        ].forEach { addArrangedSubview($0) }
        
        [
            defaultImageView,
            messageLabel
        ].forEach { messageStackView.addArrangedSubview($0) }
        
        [
            deleteButton,
            cancelButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageStackView.widthAnchor.constraint(
                equalToConstant: Consts.Cart.widthMessageStackView
            ),
            buttonStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            buttonStackView.widthAnchor.constraint(
                equalTo: widthAnchor
            )
        ])
    }
}
