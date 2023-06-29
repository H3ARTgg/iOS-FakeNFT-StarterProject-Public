import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? = URL(string: "https://648cbbde8620b8bae7ed50c4.mockapi.io/api/v1/profile/1")
    var httpMethod: HttpMethod = .get
}
