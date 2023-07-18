import Foundation

struct ProfileRequestGet: NetworkRequest {
    var endpoint: URL? {
        URL(string: basicEndpoint + "/profile/1")
    }
}

struct ProfileRequestPut: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var endpoint: URL? {
        URL(string: basicEndpoint + "/profile/1")
    }
    var dto: Encodable?
}

struct NftGetRequest: NetworkRequest {
    var id: String
    var endpoint: URL? {
        URL(string: basicEndpoint + "/nft/" + id)
    }
}

struct UserNameRequest: NetworkRequest {
    var id: String
    var endpoint: URL? {
        URL(string: basicEndpoint + "/users/" + id)
    }
}
