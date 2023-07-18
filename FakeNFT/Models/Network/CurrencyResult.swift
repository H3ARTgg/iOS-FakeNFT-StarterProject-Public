import Foundation

struct CurrencyResult: Codable {
    let title: String
    let name: String
    let image: String
    let id: String
    
    func convert() -> Currency {
        Currency(
            title: title,
            name: name,
            image: image,
            id: id
        )
    }
}
