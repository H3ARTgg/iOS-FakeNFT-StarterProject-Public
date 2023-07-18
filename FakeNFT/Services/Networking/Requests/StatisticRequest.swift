import Foundation

enum StatisticFilter: String {
    case name
    case rating
}

struct StatiscticRequest: NetworkRequest {
    var endpoint: URL?
    var queryParameters: [String: String]?
    var httpMethod: HttpMethod
}
