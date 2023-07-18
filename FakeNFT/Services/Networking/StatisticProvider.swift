import Foundation

protocol StatisticProviderProtocol {
   mutating func fetchUsersNextPage(completion: @escaping (Result<[UserNetworkModel], Error>) -> Void)
}

struct StatisticProvider {
    private let networkClient = DefaultNetworkClient()
}

extension StatisticProvider: StatisticProviderProtocol {
    mutating func fetchUsersNextPage(
        completion: @escaping (Result<[UserNetworkModel], Error>
        ) -> Void) {
        assert(Thread.isMainThread)
      
        let networkRequest = StatiscticRequest(
            endpoint: Consts.Statistic.urlStatistic,
            queryParameters: nil,
            httpMethod: .get
        )
        
        networkClient.send(request: networkRequest, type: [UserNetworkModel].self) { result in
            switch result {
            case .success(let model):
                completion(.success(model))        
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
