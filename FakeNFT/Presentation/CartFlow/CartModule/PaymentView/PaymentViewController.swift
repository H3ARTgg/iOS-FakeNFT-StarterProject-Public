import UIKit

protocol PaymentViewControllerDelegate: AnyObject {
    func openWebViewController()
    func openPaymentResult()
}

final class PaymentViewController: UIViewController {
    
    private var cartViewModel: CartViewModelProtocol
    private var paymentViewModel: PaymentViewModelProtocol
    private var paymentResultViewModel: PaymentResultViewModelProtocol
    
    private var selectedIndexPath: IndexPath?
    private var currencyId: String?
    
    weak var updateDelegate: UpdateCurrenciesDelegate?
    
    init(
        cartViewModel: CartViewModelProtocol,
        paymentViewModel: PaymentViewModelProtocol = PaymentViewModel(),
        paymentResultViewModel: PaymentResultViewModelProtocol = PaymentResultViewModel()
    ) {
        self.cartViewModel = cartViewModel
        self.paymentViewModel = paymentViewModel
        self.paymentResultViewModel = paymentResultViewModel
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
        
        if paymentViewModel.isLoadCompleted {
            updateDelegate?.updateCollectionView()
        } else {
            UIProgressHUD.show()
        }
        
        paymentViewModel.bind { [weak self] _ in
            self?.updateDelegate?.updateCollectionView()
            UIProgressHUD.dismiss()
        }
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
        paymentViewModel.currenciesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.Cart.CellIdentifier.currencyCartViewCell, for: indexPath) as? CurrencyCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let currency = paymentViewModel.currenciesList[indexPath.row]
        
        cell.configure(currency)
        
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndexPath != nil {
            if let cell = collectionView.cellForItem(at: selectedIndexPath ?? IndexPath()) {
                cell.layer.borderWidth = 0
            }
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            let currency = paymentViewModel.currenciesList[indexPath.row]
            currencyId = currency.id
            
            cell.layer.cornerRadius = 12
            cell.layer.borderWidth = 1
            cell.layer.borderColor = Asset.Colors.ypBlack.color.cgColor
            selectedIndexPath = indexPath
        }
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
        webView.tabBarController?.tabBar.isHidden = false
        navigationController?.pushViewController(webView, animated: true)
    }
    
    func openPaymentResult() {
        if currencyId != nil {
            guard let currencyId else { return }
            
            let paymentResultViewController = PaymentResultViewController(
                cartViewModel: cartViewModel,
                paymentResultViewModel: paymentResultViewModel
            )
            paymentResultViewController.modalPresentationStyle = .fullScreen
                    
            navigationController?.pushViewController(paymentResultViewController, animated: true)
            
            paymentResultViewModel.fetchPaymentResult(currencyId)
        } else {
            // alert
        }
    }
}
