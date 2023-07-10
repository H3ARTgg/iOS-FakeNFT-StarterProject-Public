import UIKit

protocol PaymentResultViewControllerDelegate: AnyObject {
    func closePaymentResultViewController()
}

final class PaymentResultViewController: UIViewController {
    
    private var cartViewModel: CartViewModelProtocol
    private var paymentResultViewModel: PaymentResultViewModelProtocol
    
    private var image: UIImage?
    private var textLabel: String?
    private var textButton: String?
    
    weak var updateDelegate: PaymentResultViewDelegate?
    
    init(
        cartViewModel: CartViewModelProtocol,
        paymentResultViewModel: PaymentResultViewModelProtocol
    ) {
        self.cartViewModel = cartViewModel
        self.paymentResultViewModel = paymentResultViewModel
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

        paymentResultViewModel.bind { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .success:
                    self?.image = Asset.Assets.successResult.image
                    self?.textLabel =
                            """
                            Успех! Оплата прошла,
                            поздравляем с покупкой!
                            """
                    self?.textButton = "Вернуться в каталог"
                case .failure:
                    self?.image = Asset.Assets.failResult.image
                    self?.textLabel =
                            """
                            Упс! Что-то пошло не так :(
                            Попробуйте ещё раз!
                            """
                    self?.textButton = "Попробовать еще раз"
                default:
                    break
                }
                
                self?.updateDelegate?.updateUi(
                    self?.image ?? UIImage(),
                    self?.textLabel ?? "",
                    self?.textButton ?? ""
                )
                UIProgressHUD.dismiss()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
}

extension PaymentResultViewController: PaymentResultViewControllerDelegate {
    func closePaymentResultViewController() {
        cartViewModel.updateCart()
        navigationController?.popToRootViewController(animated: true)
    }
}
