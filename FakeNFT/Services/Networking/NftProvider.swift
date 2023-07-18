import Foundation

protocol NftProviderProtocol {
    func fetchNfts(nftsId: [String], _ completion: @escaping (Result<[NftResponseModel], Error>) -> Void)
}

struct NftProvider {
    private let networkClient = DefaultNetworkClient()
}

extension NftProvider: NftProviderProtocol {
    
    func fetchNfts(nftsId: [String], _ completion: @escaping (Result<[NftResponseModel], Error>) -> Void) {
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
