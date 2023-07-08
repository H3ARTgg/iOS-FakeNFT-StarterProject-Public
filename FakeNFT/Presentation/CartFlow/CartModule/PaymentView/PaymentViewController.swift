import UIKit

protocol PaymentViewControllerDelegate: AnyObject {
    func openWebViewController()
}

final class PaymentViewController: UIViewController {
    
    private var viewModel: PaymentViewModelProtocol
    
    weak var updateDelegate: UpdateCurrenciesDelegate?
    
    init(viewModel: PaymentViewModelProtocol = PaymentViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        tabBarController?.tabBar.isHidden = true
        let customView = PaymentViewCollection(frame: view.frame)
        customView.configure(delegate: self)
        updateDelegate = customView
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        
        if viewModel.isLoadCompleted {
            updateDelegate?.updateCollectionView()
        } else {
            UIProgressHUD.show()
        }
        
        viewModel.bind { [weak self] _ in
            self?.updateDelegate?.updateCollectionView()
            UIProgressHUD.dismiss()
        }
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

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.currenciesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.Cart.CellIdentifier.currencyCartViewCell, for: indexPath) as? CurrencyCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let currency = viewModel.currenciesList[indexPath.row]
        
        cell.configure(currency)
        
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace: CGFloat = 14 * (2 + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 7, right: 16)
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
