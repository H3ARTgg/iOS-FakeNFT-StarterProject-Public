import Foundation

struct PaymentResultRequest: NetworkRequest {
    var id: String
    var endpoint: URL? {
        URL(string: "\(Consts.Cart.Url.baseURL)orders/1/payment/\(id)")
    }
    var httpMethod: HttpMethod = .get
}
