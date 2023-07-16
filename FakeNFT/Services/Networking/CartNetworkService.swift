import Foundation

protocol CartNetworkServiceProtocol {
    func fetchProducts(_ completion: @escaping (Result<[Nft], Error>) -> Void)
    func putProducts(productIds: [String])
}

final class CartNetworkService {
    private let baseURL = Consts.Cart.Url.baseUrl
    private let session = URLSession.shared
    private let networkClient: DefaultNetworkClient
    
    private var idProducts = [String]()
    
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    
    private func fetchNfts(_ completion: @escaping (Result<[Nft], Error>) -> Void) {
        let group = DispatchGroup()
        var fetchedProducts: [Nft] = []
        
        for id in idProducts {
            group.enter()

            guard let url = URL(string: "\(baseURL)nft/\(id)") else {
                group.leave()
                continue
            }
            
            let request = URLRequest(url: url)
            
            session.dataTask(with: request) { data, _, error in
                defer { group.leave() }
                if let data = data, let nftResult = try? JSONDecoder().decode(NftResult.self, from: data) {
                    fetchedProducts.append(nftResult.convert())
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        }
        group.notify(queue: .main) {
            completion(.success(fetchedProducts))
        }
    }
}

extension CartNetworkService: CartNetworkServiceProtocol {
    func fetchProducts(_ completion: @escaping (Result<[Nft], Error>) -> Void) {
        let request = OrderRequest()
        
        networkClient.send(request: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    let order = try JSONDecoder().decode(OrderResult.self, from: data)
                    self.idProducts = order.nfts
                    self.fetchNfts(completion)
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func putProducts(productIds: [String]) {
        var request = OrderRequestPut()
        request.dto = OrderResult(nfts: productIds)
        
        networkClient.send(request: request, onResponse: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.idProducts = []
                }
            case .failure(let error):
                print("failed to put order: \(error)")
            }
        })
    }
}
