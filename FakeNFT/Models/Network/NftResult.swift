import Foundation

struct NftResult: Codable {
    let name: String?
    let images: [String]?
    let rating: Int?
    let price: Float?
    let id: String?
    
    func convert() -> Nft {
        Nft(
            id: Int(self.id ?? "") ?? 0,
            name: self.name ?? "",
            image: self.images?[0] ?? "",
            rating: self.rating ?? 0,
            price: Double(self.price ?? 0)
        )
    }
}
