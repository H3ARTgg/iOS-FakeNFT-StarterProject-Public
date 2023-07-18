import Foundation

struct OrderRequestPutCatalogue: NetworkRequest {
    var endpoint: URL? = URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/orders/1")
    var httpMethod: HttpMethod = .put
    var dto: Encodable?
}

struct OrderRequestGet: NetworkRequest {
    var endpoint: URL? = URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/orders/1")
    var httpMethod: HttpMethod = .get
}

struct CollectionRequestGet: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod = .get

    init(id: String) {
        endpoint = URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/collections/\(id)")
    }
}

struct CollectionsRequestGet: NetworkRequest {
    var endpoint: URL? = URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/collections")
    var httpMethod: HttpMethod = .get
}

struct NftsRequestGet: NetworkRequest {
    var endpoint: URL? = URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/nft")
    var httpMethod: HttpMethod = .get
}
