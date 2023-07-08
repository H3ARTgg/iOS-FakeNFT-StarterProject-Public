import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? = URL(string: "\(Consts.Cart.Url.baseURL)orders/1")
    var httpMethod: HttpMethod = .get
}
