import Foundation

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