import UIKit

final class CollectionDetailsCellViewModel: Identifiable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    
    init(nft: NFT) {
        self.name = nft.name
        self.images = nft.images
        self.rating = nft.rating
        self.price = nft.price
    }
    
    func downloadImageFor(_ imageView: UIImageView) {
        
    }
    
    func getImageForRating() -> UIImage {
        return Rating(rating).image
    }
    
}
