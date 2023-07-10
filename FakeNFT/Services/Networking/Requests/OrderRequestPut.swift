import Foundation

struct OrderRequestPut: NetworkRequest {
    var endpoint: URL? = URL(string: "\(Consts.Cart.Url.baseURL)orders/1")
    var httpMethod: HttpMethod = .put
    var dto: Encodable?
}
