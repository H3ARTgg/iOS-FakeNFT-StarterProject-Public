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
                            Успех! Оплата прошла,
                            поздравляем с покупкой!
                            """
            textButton = "Вернуться в каталог"
            UIProgressHUD.dismiss()
        case .failure:
            image = Asset.Assets.failResult.image
            textLabel =
                            """
                            Упс! Что-то пошло не так :(
                            Попробуйте ещё раз!
                            """
            textButton = "Попробовать еще раз"
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
