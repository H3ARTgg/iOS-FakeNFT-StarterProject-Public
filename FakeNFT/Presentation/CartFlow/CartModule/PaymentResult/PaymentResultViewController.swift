import UIKit

protocol PaymentResultViewControllerDelegate: AnyObject {
    func closePaymentResultViewController()
}

final class PaymentResultViewController: UIViewController {
    
    private var cartViewModel: CartViewModelProtocol
    
    private var image: UIImage?
    private var textLabel: String?
    private var textButton: String?
    
    var state: ViewState = .loading
    
    weak var updateDelegate: PaymentResultViewDelegate?
    
    init(
        cartViewModel: CartViewModelProtocol
    ) {
        self.cartViewModel = cartViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let customView = PaymentResultView()
        customView.delegate = self
        customView.configure()
        view = customView
        updateDelegate = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        UIProgressHUD.show()
        
        switch state {
        case .success:
            image = Asset.Assets.successResult.image
            textLabel =
                            """
                            \(L10n.Cart.ResultPayment.successTitle)
                            \(L10n.Cart.ResultPayment.successCongratulationTitle)
                            """
            textButton = L10n.Cart.ResultPayment.successButton
            UIProgressHUD.dismiss()
        case .failure:
            image = Asset.Assets.failResult.image
            textLabel =
                            """
                            \(L10n.Cart.ResultPayment.failureTitle)
                            \(L10n.Cart.ResultPayment.failureTryTitle)
                            """
            textButton = L10n.Cart.ResultPayment.failureButton
            UIProgressHUD.dismiss()
        default:
            break
        }
        
        updateDelegate?.updateUi(
            image ?? UIImage(),
            textLabel ?? "",
            textButton ?? ""
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
}

extension PaymentResultViewController: PaymentResultViewControllerDelegate {
    func closePaymentResultViewController() {
        cartViewModel.updateCart()
    }
}
