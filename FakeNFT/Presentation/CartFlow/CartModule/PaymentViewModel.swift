import Foundation

enum ViewState {
    case loading
    case success
    case failure
}

protocol PaymentCoordination: AnyObject {
    var handleTermsScreenOpening: ((URL) -> Void)? { get set }
    var handlePaymentResultScreenPresentation: ((ViewState) -> Void)? { get set }
    var handleCartScreenReturn: (() -> Void)? { get set }
    var handleForAlert: ((AlertModel) -> Void)? { get set }
}

protocol PaymentViewModelProtocol {
    var currenciesList: [Currency] { get }
    var isLoadCompleted: Bool { get }
    func fetchPaymentResult(_ currencyId: String)
    func bind(updateViewController: @escaping ([Currency]) -> Void)
    func showTerms()
    func closePaymentViewController()
    func showErrorAlert()
}

final class PaymentViewModel: ObservableObject, PaymentCoordination {
    @Observable var currencies: [Currency] = []
    
    private var paymentNetworkService: PaymentNetworkServiceProtocol
    
    private var isInitialLoadCompleted = false
        
    var handleTermsScreenOpening: ((URL) -> Void)?
    var handlePaymentResultScreenPresentation: ((ViewState) -> Void)?
    var handleCartScreenReturn: (() -> Void)?
    var handleForAlert: ((AlertModel) -> Void)?
    
    init(paymentNetworkService: PaymentNetworkServiceProtocol) {
        self.paymentNetworkService = paymentNetworkService
        fetchCurrencies()
    }
    
    private func fetchCurrencies() {
        paymentNetworkService.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    self?.currencies = currencies
                    self?.isInitialLoadCompleted = true
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension PaymentViewModel: PaymentViewModelProtocol {
    var currenciesList: [Currency] {
        currencies
    }
    
    var isLoadCompleted: Bool {
        isInitialLoadCompleted
    }
    
    func fetchPaymentResult(_ currencyId: String) {
        paymentNetworkService.fetchPaymentResult(currencyId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let paymentResult):
                    if paymentResult.success {
                        self.handlePaymentResultScreenPresentation?(.success)
                    } else {
                        self.handlePaymentResultScreenPresentation?(.failure)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func bind(updateViewController: @escaping ([Currency]) -> Void) {
        $currencies.bind(action: updateViewController)
    }
    
    func showTerms() {
        guard let url = URL(string: Consts.Cart.Url.termsUrl) else { return }
        handleTermsScreenOpening?(url)
    }
    
    func closePaymentViewController() {
        handleCartScreenReturn?()
    }
    
    func showErrorAlert() {
        let errorAlert = createErrorAlertModel()
        handleForAlert?(errorAlert)
    }
}

extension PaymentViewModel {
    private func createErrorAlertModel() -> AlertModel {
        let alertTitle = L10n.Cart.Alert.Payment.title
        let alertMessage = L10n.Cart.Alert.Payment.message
        let confirmationActionTitle = L10n.Cart.Alert.Payment.action
        
        let confirmationAction = AlertAction(
            actionText: confirmationActionTitle,
            actionRole: .regular,
            action: nil
        )
        
        let alertModel = AlertModel(
            alertText: alertTitle,
            message: alertMessage,
            alertActions: [confirmationAction]
        )
        
        return alertModel
    }
}
