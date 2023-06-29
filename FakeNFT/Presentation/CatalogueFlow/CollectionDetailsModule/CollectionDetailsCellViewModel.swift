import UIKit

final class CollectionDetailsCellViewModel: Identifiable {
    let id: String
    let name: String
    let price: Float
    @Observable private(set) var isFavorite: Bool = false
    private let images: [String]
    private let rating: Int
    private let networkClient: NetworkClient
    private var likesNftIds: [String] = []
    
    init(nft: NFT, networkClient: NetworkClient) {
        self.name = nft.name
        self.images = nft.images
        self.rating = nft.rating
        self.price = nft.price
        self.id = nft.id
        self.networkClient = networkClient
        isInFavoritesFor(nft.id)
    }
    
    func downloadImageFor(_ imageView: UIImageView) {
        
    }
    
    func getImageForRating() -> UIImage {
        return Rating(rating).image
    }
    
    func didTapFavorite() {
        changeFavoritesForNFT()
    }
    private func isInFavoritesFor(_ nftId: String) {
        let request = ProfileRequest()
        DispatchQueue.global().async { [weak self] in
            self?.networkClient.send(request: request, type: LikesResult.self, onResponse: { (result: Result<LikesResult, Error>) in
                switch result {
                case .success(let likes):
                    DispatchQueue.main.async {
                        self?.likesNftIds = likes.likes
                        if likes.likes.contains(nftId) {
                            self?.isFavorite = true
                        } else {
                            self?.isFavorite = false
                        }
                    }
                case .failure(let error):
                    print("failed isInFavorites: \(error)")
                }
            })
        }
    }
    
    private func changeFavoritesForNFT() {
        var likesIds = likesNftIds
        var request = AddToFavoritesRequest()
        if isFavorite {
            likesIds = likesIds.filter({ $0 != id })
        } else {
            likesIds.append(id)
        }
        request.dto = LikesResult(likes: likesIds)
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            self.networkClient.send(request: request) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.likesNftIds = likesIds
                        if likesIds.contains(self.id) {
                            self.isFavorite = true
                        } else {
                            self.isFavorite = false
                        }
                    }
                case .failure(let error):
                    print("failed to put likes: \(error)")
                }
            }
        }
    }
}
