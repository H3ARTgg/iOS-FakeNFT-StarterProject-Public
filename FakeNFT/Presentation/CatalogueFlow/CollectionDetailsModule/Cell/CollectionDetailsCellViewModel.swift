import UIKit

final class CollectionDetailsCellViewModel: Identifiable {
    let id: String
    let name: String
    let price: Float
    @Observable private(set) var isInCart: Bool = false
    @Observable private(set) var isFavorite: Bool = false
    private let images: [String]
    private let rating: Int
    private let networkClient: NetworkClient
    private var orderNftsIds: [String] = []
    private var likesNftIds: [String] = []
    
    init(nft: NFT, networkClient: NetworkClient) {
        self.name = nft.name
        self.images = nft.images
        self.rating = nft.rating
        self.price = nft.price
        self.id = nft.id
        self.networkClient = networkClient
        isInOrderFor(nft.id)
        isInFavoritesFor(nft.id)
    }
    
    func downloadImageFor(_ imageView: UIImageView) {
        imageView.kf.setImage(with: URL(string: images[0]))
    }
    
    func getImageForRating() -> UIImage {
        return Rating(rating).image
    }
    
    func didTapCart() {
        changeOrderStateForNFT()
    }
    
    func didTapFavorite() {
        changeFavoritesForNFT()
    }
    
    private func isInOrderFor(_ nftId: String) {
        let request = OrderRequest()
        DispatchQueue.global().async { [weak self] in
            self?.networkClient.send(request: request, type: OrderResult.self) { (result: Result<OrderResult, Error>) in
                switch result {
                case .success(let order):
                    DispatchQueue.main.async {
                        self?.orderNftsIds = order.nfts
                        if order.nfts.contains(nftId) {
                            self?.isInCart = true
                        } else {
                            self?.isInCart = false
                        }
                    }
                case .failure(let error):
                    print("failed order request: \(error)")
                }
            }
        }
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
    
    private func changeOrderStateForNFT() {
        var orderIds = orderNftsIds
        var request = AddToOrderRequest()
        if isInCart {
            orderIds = orderIds.filter({ $0 != id })
        } else {
            orderIds.append(id)
        }
        request.dto = OrderModel(nfts: orderIds)
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            self.networkClient.send(request: request, onResponse: { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.orderNftsIds = orderIds
                        if orderIds.contains(self.id) {
                            self.isInCart = true
                        } else {
                            self.isInCart = false
                        }
                    }
                case .failure(let error):
                    print("failed to put order: \(error)")
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
