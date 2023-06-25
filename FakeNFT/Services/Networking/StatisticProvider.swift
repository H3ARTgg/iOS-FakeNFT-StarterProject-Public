import Foundation

protocol StatisticProviderProtocol {
    func fetchUsersNextPage(isRefresh: Bool, filter: StatisticFilter, completion: @escaping (Result<[User], Error>) -> Void)
}

final class StatisticProvider {
    private let networkClient = DefaultNetworkClient()
    private var lastLoadedPage: Int?
}

extension StatisticProvider: StatisticProviderProtocol {
    func fetchUsersNextPage(
        isRefresh: Bool,
        filter: StatisticFilter,
        completion: @escaping (Result<[User], Error>
        ) -> Void) {
        assert(Thread.isMainThread)
        guard let url = Consts.Statistic.urlStatistic else { return }
        
        if isRefresh { lastLoadedPage = nil }
        var nextPage: Int
        
        if let lastLoadedPage = lastLoadedPage {
            nextPage = lastLoadedPage + 1
            self.lastLoadedPage = nextPage
        } else {
            nextPage = 1
            self.lastLoadedPage = nextPage
        }
        
        let networkRequest = StatiscticRequest(
            endpoint: url,
            queryParameters: [
                "page": "\(nextPage)",
                "limit": "\(Consts.Statistic.limiteUsersOnPage)",
                "sortBy": filter.rawValue
            ],
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
                                rating: result.rating,
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
