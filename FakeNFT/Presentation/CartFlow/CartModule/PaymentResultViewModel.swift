import Foundation

enum ViewState {
    case loading
    case success
    case failure
}

protocol PaymentResultViewModelProtocol {
    var stateView: ViewState { get }
    func fetchPaymentResult(_ currencyId: String)
    func bind(updateUi: @escaping (ViewState) -> Void)
}

final class PaymentResultViewModel: ObservableObject {
    @Observable var state: ViewState = .loading
    
    private let paymentNetworkService: PaymentNetworkServiceProtocol
    
    init(paymentNetworkService: PaymentNetworkServiceProtocol = PaymentNetworkService()) {
        self.paymentNetworkService = paymentNetworkService
    }
}

extension PaymentResultViewModel: PaymentResultViewModelProtocol {
    var stateView: ViewState {
        state
    }
    
    func fetchPaymentResult(_ currencyId: String) {
        paymentNetworkService.fetchPaymentResult(currencyId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let paymentResult):
                    if paymentResult.success {
                        self?.state = .success
                    } else {
                        self?.state = .failure
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func bind(updateUi: @escaping (ViewState) -> Void) {
        $state.bind(action: updateUi)
    }
}
