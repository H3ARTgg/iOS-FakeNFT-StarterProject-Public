import Foundation
import UIKit
import Kingfisher

final class CollectionDetailsViewModel {
    private var collectionId: String
    private var networkClient: NetworkClient
    @Observable private(set) var nftCollection: NFTCollectionResponce?
    @Observable private(set) var nfts: [CollectionDetailsCellViewModel] = []
    
    init(collectionId: String, networkClient: NetworkClient) {
        self.collectionId = collectionId
        self.networkClient = networkClient
        requestCollection()
    }
    
    func requestCollection() {
        let request = CollectionRequestGet(id: collectionId)
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.networkClient.send(request: request, type: NFTCollectionResponce.self) { (result: Result<NFTCollectionResponce, Error>) in
                switch result {
                case .success(let collection):
                    DispatchQueue.main.async {
                        self.nftCollection = collection
                    }
                    self.requestNfts(collection.nfts)
                case .failure(let error):
                    print("failed collection: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getViewModelForCellAt(_ indexPath: IndexPath) -> CollectionDetailsCellViewModel {
        return nfts[indexPath.row]
    }
    
    func downloadImageFor(_ imageView: UIImageView) {
        guard let nftCollection else { return }
        imageView.kf.setImage(
            with:
                URL(string: nftCollection.cover
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                )
        )
    }
    
    func getViewModelForWebView(with url: URL) -> WebViewViewModelProtocol {
        WebViewViewModel(url: url)
    }
    
    private func requestNfts(_ ids: [String]) {
        // Загружаю все NFT, так как иначе быстрее достигается лимит запросов.
        let request = NftsRequestGet()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            self.networkClient.send(request: request, type: [NFT].self, onResponse: { (result: Result<[NFT], Error>) in
                switch result {
                case .success(let nfts):
                    DispatchQueue.main.async {
                        ids.forEach { id in
                            if let nft = nfts.first(where: { $0.id == id }) {
                                self.nfts.append(
                                    CollectionDetailsCellViewModel(
                                        nft: nft,
                                        networkClient: self.networkClient
                                    )
                                )
                            }
                        }
                    }
                case .failure(let error):
                    print("failed nft: \(error.localizedDescription)")
                }
            })
        }
    }
}
