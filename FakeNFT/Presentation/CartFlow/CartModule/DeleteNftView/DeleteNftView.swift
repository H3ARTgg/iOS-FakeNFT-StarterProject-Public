import UIKit

final class DeleteNftView: UIView {
    
    // MARK: - Properties
    private let mainStackView = DeleteNftStackView()
    
    // MARK: - Helpers
    func configure(delegate: DeleteNftViewController) {
        setupBlur()

        mainStackView.delegate = delegate
        
        addSubview(mainStackView)
        setupConstraints()
    }
    
    // MARK: - Private methods
    private func setupBlur() {
        backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 56
            ),
            mainStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -57
            ),
            mainStackView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            )
        ])
    }
}
