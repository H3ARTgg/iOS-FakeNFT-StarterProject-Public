import Foundation

protocol NftProviderProtocol {
    func fetchNft(id: String, completion: @escaping (Result<Nft, Error>) -> Void)
}

struct NftProvider {
    private let networkClient = DefaultNetworkClient()
}

extension NftProvider: NftProviderProtocol {
    func fetchNft(id: String, completion: @escaping (Result<Nft, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let urlString = Consts.Statistic.urlNft?.absoluteString,
              let url = URL(string: urlString + id) else { return }
        let networkRequest = NftRequest(endpoint: url, httpMethod: .get)
        networkClient.send(request: networkRequest, type: NftNetworkModel.self) { result in
            switch result {
            case .success(let model):
                let nft = Nft(
                    createdAt: model.createdAt,
                    name: model.name,
                    images: model.images,
                    rating: model.rating,
                    description: model.description,
                    price: model.price,
                    author: model.author,
                    id: model.id
                )
                completion(.success(nft))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
