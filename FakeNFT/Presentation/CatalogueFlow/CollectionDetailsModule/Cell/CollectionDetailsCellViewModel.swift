import UIKit

final class CollectionDetailsCellViewModel: Identifiable {
    let id: String
    let name: String
    let price: Float
    @Observable private(set) var isInCart: Bool = false
    @Observable private(set) var isFavorite: Bool = false
    @Observable private(set) var isFailed: Bool = false
    private let images: [String]
    private let rating: Int
    private let networkClient: NetworkClient
    private var orderNftsIds: [String] = []
    private var likesNftIds: [String] = []
    private let dispatchGroup = DispatchGroup()
    private var currentTask: NetworkTask?
    
    init(nft: NftResponseModel, networkClient: NetworkClient) {
        self.name = nft.name
        self.images = nft.images
        self.rating = nft.rating
        self.price = Float(nft.price)
        self.id = nft.id
        self.networkClient = networkClient
        isInOrderFor(nft.id)
        isInFavoritesFor(nft.id)
    }
    
    func downloadImageFor(_ imageView: UIImageView) {
        imageView.kf.setImage(with: URL(string: images[0]), options: [.transition(.fade(0.75))])
    }
    
    func getImageForRating() -> UIStackView {
        let stackView = RatingStackView()
        stackView.setupRating(rating)
        return stackView
    }
    
    func didTapCart() {
        if let currentTask {
            currentTask.cancel()
        }
        changeOrderStateForNFT()
    }
    
    func didTapFavorite() {
        if let currentTask {
            currentTask.cancel()
        }
        changeFavoritesForNFT()
    }
    
    private func isInOrderFor(_ nftId: String) {
        dispatchGroup.enter()
        let request = OrderRequest()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            self.currentTask = self.networkClient.send(request: request, type: OrderResult.self) { (result: Result<OrderResult, Error>) in
                switch result {
                case .success(let order):
                    DispatchQueue.main.async {
                        self.orderNftsIds = order.nfts
                    }
                case .failure(let error):
                    print("failed order request: \(error)")
                    self.isFailed = true
                }
                self.dispatchGroup.leave()
            }
        }
    }
    
    private func isInFavoritesFor(_ nftId: String) {
        dispatchGroup.enter()
        let request = ProfileRequestGet()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            self.currentTask = self.networkClient.send(request: request, type: LikesNetworkModel.self, onResponse: { (result: Result<LikesNetworkModel, Error>) in
                switch result {
                case .success(let likes):
                    DispatchQueue.main.async {
                        self.likesNftIds = likes.likes
                    }
                case .failure(let error):
                    print("failed isInFavorites: \(error)")
                    self.isFailed = true
                }
                self.dispatchGroup.leave()
            })
        }
    }
    
    private func changeOrderStateForNFT() {
        isInOrderFor(id) // для обновления orderNftIds
        dispatchGroup.notify(queue: .global()) { [weak self] in
            guard let self else { return }
            
            var orderIds = self.orderNftsIds
            var request = OrderRequestPut()
            if self.isInCart {
                orderIds = orderIds.filter({ $0 != self.id })
            } else {
                orderIds.append(self.id)
            }
            request.dto = OrderResult(nfts: orderIds)
            
            self.currentTask = self.networkClient.send(request: request, onResponse: { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if orderIds.contains(self.id) {
                            self.isInCart = true
                        } else {
                            self.isInCart = false
                        }
                    }
                case .failure(let error):
                    print("failed to put order: \(error)")
                    self.isFailed = true
                }
            })
            
        }
    }
    
    private func changeFavoritesForNFT() {
        isInFavoritesFor(id) // для обновления likesNftIds до актуальных лайков
        dispatchGroup.notify(queue: .global()) { [weak self] in
            guard let self else { return }
            
            var likesIds = self.likesNftIds
            var request = ProfileRequestPut()
            if self.isFavorite {
                likesIds = likesIds.filter({ $0 != self.id })
            } else {
                likesIds.append(self.id)
            }
            request.dto = LikesNetworkModel(likes: likesIds)
            
            self.currentTask = self.networkClient.send(request: request) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if likesIds.contains(self.id) {
                            self.isFavorite = true
                        } else {
                            self.isFavorite = false
                        }
                    }
                case .failure(let error):
                    print("failed to put likes: \(error)")
                    self.isFailed = true
                }
            }
        }
    }
}
