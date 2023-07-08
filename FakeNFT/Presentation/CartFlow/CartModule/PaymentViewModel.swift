import Foundation

protocol PaymentViewModelProtocol {
    var currenciesList: [Currency] { get }
    func bind(updateViewController: @escaping ([Currency]) -> Void)
}

final class PaymentViewModel: ObservableObject {
    @Observable var currencies: [Currency] = []
    
    private var paymentNetworkService: PaymentNetworkServiceProtocol
    
    private var isInitialLoadCompleted = false
    
    init(paymentNetworkService: PaymentNetworkServiceProtocol = PaymentNetworkService()) {
        self.paymentNetworkService = paymentNetworkService
        fetchCurrencies()
    }
    
    private func fetchCurrencies() {
        paymentNetworkService.fetchProducts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    self.currencies = currencies
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
    
    func bind(updateViewController: @escaping ([Currency]) -> Void) {
        $currencies.bind(action: updateViewController)
    }
}
