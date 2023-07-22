import Foundation

protocol NftProviderProtocol {
    func fetchNfts(nftsId: [String], _ completion: @escaping (Result<[NftResponseModel], Error>) -> Void)
    func fetchFavoriteNFT(_ completion: @escaping (Result<[String], Error>) -> Void)
    func changeFavoritesForNFT(favoriteNFT: [String], _ completion: @escaping (Result<Void, Error>) -> Void)
}

struct NftProvider {
    private let networkClient = DefaultNetworkClient()
}

extension NftProvider: NftProviderProtocol {
    func fetchNfts(nftsId: [String], _ completion: @escaping (Result<[NftResponseModel], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let group = DispatchGroup()
            var fetchedProducts: [NftResponseModel] = []

            for id in nftsId {
                group.enter()

                guard let urlString = Consts.Statistic.urlNft?.absoluteString,
                      let url = URL(string: urlString + id)
                else {
                    group.leave()
                    continue
                }

                let request = URLRequest(url: url)

                URLSession.shared.dataTask(with: request) { data, _, error in
                    defer { group.leave() }
                    if let data = data, let nftResult = try? JSONDecoder().decode(NftResponseModel.self, from: data) {
                        fetchedProducts.append(nftResult)
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

    func fetchFavoriteNFT(_ completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let networkRequest = ProfileRequestGet()
            networkClient.send(request: networkRequest, type: ProfileResponseModel.self) { result in
                switch result {
                case .success(let model):
                    completion(.success(model.likes))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func changeFavoritesForNFT(favoriteNFT: [String], _ completion: @escaping (Result<Void, Error>) -> Void) {
        var request = ProfileRequestPut()
        request.dto = LikesNetworkModel(likes: favoriteNFT)
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
