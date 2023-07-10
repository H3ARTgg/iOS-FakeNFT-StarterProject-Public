import Foundation

protocol NftProviderProtocol {
    func fetchNft(id: String, completion: @escaping (Result<NftNetworkModel, Error>) -> Void)
}

struct NftProvider {
    private let networkClient = DefaultNetworkClient()
}

extension NftProvider: NftProviderProtocol {
    func fetchNft(id: String, completion: @escaping (Result<NftNetworkModel, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let urlString = Consts.Statistic.urlNft?.absoluteString,
              let url = URL(string: urlString + id) else { return }
        let networkRequest = NftRequest(endpoint: url, httpMethod: .get)
        networkClient.send(request: networkRequest, type: NftNetworkModel.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
