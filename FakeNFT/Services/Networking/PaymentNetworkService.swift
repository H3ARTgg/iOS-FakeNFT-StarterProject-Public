import Foundation

protocol PaymentNetworkServiceProtocol {
    func fetchProducts(_ completion: @escaping (Result<[Currency], Error>) -> Void)
}

final class PaymentNetworkService {
    private let baseURL = Consts.Cart.Url.baseURL
    private let networkClient: DefaultNetworkClient
    
    init(networkClient: DefaultNetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}

extension PaymentNetworkService: PaymentNetworkServiceProtocol {
    func fetchProducts(_ completion: @escaping (Result<[Currency], Error>) -> Void) {
        let request = CurrenciesRequest()
        
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let currenciesResult = try JSONDecoder().decode([CurrencyResult].self, from: data)
                    let currencies = currenciesResult.map { $0.convert() }
                    completion(.success(currencies))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
