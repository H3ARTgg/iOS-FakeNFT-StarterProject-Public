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
                    self.nftCollection = nil
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
        ids.forEach { [weak self] in
            guard let self else { return }
            
            let request = NftGetRequest(id: $0)
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                
                self.networkClient.send(request: request, type: NFT.self, onResponse: { (result: Result<NFT, Error>) in
                    switch result {
                    case .success(let nft):
                        DispatchQueue.main.async {
                            self.nfts.append(
                                CollectionDetailsCellViewModel(
                                    nft: nft,
                                    networkClient: self.networkClient
                                )
                            )
                        }
                    case .failure(let error):
                        print("failed nft: \(error.localizedDescription)")
                    }
                })
            }
        }
        
    }
}
