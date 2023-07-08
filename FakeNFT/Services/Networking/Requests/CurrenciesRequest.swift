import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(Consts.Cart.Url.baseURL)currencies")
    }
    
    var httpMethod: HttpMethod = .get
}
