import Foundation

struct ProfileRequestGet: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/profile/1")
    }
}

struct ProfileRequestPut: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var endpoint: URL? {
        URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/profile/1")
    }
    var dto: Encodable?
}

struct NftGetRequest: NetworkRequest {
    var id: String
    var endpoint: URL? {
        URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/nft/" + id)
    }
}

