import UIKit

protocol DeleteNftViewControllerDelegate: AnyObject {
    func deleteNft()
    func closeViewController()
}

final class DeleteNftViewController: UIViewController {
    
    private let mainStackView = DeleteNftStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlur()
        
        mainStackView.delegate = self
        
        view.addSubview(mainStackView)
        setupConstraints()
    }
    
    private func setupBlur() {
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 56
            ),
            mainStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -57
            ),
            mainStackView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 244
            )
        ])
    }
}

extension DeleteNftViewController: DeleteNftViewControllerDelegate {
    func deleteNft() {
        
    }
    
    func closeViewController() {
        dismiss(animated: true)
    }
}
