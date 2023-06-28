import Foundation

protocol StatisticProviderProtocol {
   mutating func fetchUsersNextPage(completion: @escaping (Result<[User], Error>) -> Void)
}

struct StatisticProvider {
    private let networkClient = DefaultNetworkClient()
    private var lastLoadedPage: Int?
}

extension StatisticProvider: StatisticProviderProtocol {
    mutating func fetchUsersNextPage(
        completion: @escaping (Result<[User], Error>
        ) -> Void) {
        assert(Thread.isMainThread)
      
        let networkRequest = StatiscticRequest(
            endpoint: Consts.Statistic.urlStatistic,
            queryParameters: nil,
            httpMethod: .get
        )
        
        networkClient.send(request: networkRequest, type: [UserNetworkModel].self) { result in
            switch result {
            case .success(let success):
                let fetchedUsers = success.compactMap { result in
                    return User(name: result.name,
                                avatar: result.avatar,
                                description: result.description,
                                website: result.website,
                                nfts: result.nfts,
                                rating: Int(result.rating) ?? 0,
                                id: result.id
                    )
                }
                
                completion(.success(fetchedUsers))
        
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
