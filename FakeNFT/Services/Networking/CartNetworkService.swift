import Foundation

final class CartNetworkService {
    private let baseURL = "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/nft/"
    private let session = URLSession.shared
    private let networkClient: DefaultNetworkClient
    
    private var idProducts = [String]()
    
    init(networkClient: DefaultNetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchProducts(_ completion: @escaping (Result<[Nft], Error>) -> Void) {
        let request = OrderRequest()
        
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let order = try JSONDecoder().decode(OrderResult.self, from: data)
                    self.idProducts = order.nfts ?? []
                    self.fetchNfts(completion)
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchNfts(_ completion: @escaping (Result<[Nft], Error>) -> Void) {
        let group = DispatchGroup()
        var fetchedProducts: [Nft] = []
        
        for id in idProducts {
            group.enter()

            guard let url = URL(string: "\(baseURL)\(id)") else {
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
