import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
}

// default values
extension NetworkRequest {
    var basicEndpoint: String { "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1" }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}
