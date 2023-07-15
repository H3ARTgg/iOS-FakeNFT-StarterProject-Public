import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(Consts.Cart.Url.baseUrl)currencies")
    }
    
    var httpMethod: HttpMethod = .get
}
