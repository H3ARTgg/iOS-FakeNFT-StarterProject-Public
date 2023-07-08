import UIKit

protocol PaymentViewControllerDelegate: AnyObject {
    func openWebViewController()
}

final class PaymentViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        tabBarController?.tabBar.isHidden = true
        let customView = PaymentViewCollection(frame: view.frame)
        customView.configure(delegate: self)
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureNavBar() {
        title = Consts.LocalizedStrings.paymentTitleNavBar
        
        let backButton = UIBarButtonItem(
            image: Asset.Assets.chevronBackward.image,
            style: .done,
            target: self,
            action: #selector(close)
        )
        backButton.tintColor = Asset.Colors.ypBlack.color
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
}

extension PaymentViewController: PaymentViewControllerDelegate {
    func openWebViewController() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else { return }
        let webViewModel = WebViewViewModel(url: url)
        let webView = WebViewViewController(viewModel: webViewModel)
        navigationController?.pushViewController(webView, animated: true)
    }
}
