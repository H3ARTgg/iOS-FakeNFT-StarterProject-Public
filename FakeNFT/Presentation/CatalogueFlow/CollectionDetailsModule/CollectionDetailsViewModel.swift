import Foundation
import UIKit
import Kingfisher
import Combine

protocol CollectionDetailsCoordination: AnyObject {
    var finish: (() -> Void)? { get set }
    var headForAbout: ((String) -> Void)? { get set }
}

protocol CollectionDetailsViewModelProtocol: AnyObject {
    var nftCollectionPublisher: AnyPublisher<[NFTCollectionResponce], Never> { get }
    var nftsPublisher: AnyPublisher<[CollectionDetailsCellViewModel], Never> { get }
    func requestCollection()
    func getViewModelForCellAt(_ indexPath: IndexPath) -> CollectionDetailsCellViewModel
    func getViewModelForWebView(with url: URL) -> WebViewViewModelProtocol
    func downloadImageFor(_ imageView: UIImageView)
    func getNftsCount() -> Int
    func didSwipeRight()
    func didTapAuthorLink(with url: URL)
}

final class CollectionDetailsViewModel: CollectionDetailsViewModelProtocol, CollectionDetailsCoordination {
    var finish: (() -> Void)?
    var headForAbout: ((String) -> Void)?
    private var collectionId: String
    private var networkClient: NetworkClient
    var nftCollectionPublisher: AnyPublisher<[NFTCollectionResponce], Never> {
        nftCollectionSubject.eraseToAnyPublisher()
    }
    var nftsPublisher: AnyPublisher<[CollectionDetailsCellViewModel], Never> {
        nftsSubject.eraseToAnyPublisher()
    }
    private let nftCollectionSubject = CurrentValueSubject<[NFTCollectionResponce], Never>([])
    private let nftsSubject = CurrentValueSubject<[CollectionDetailsCellViewModel], Never>([])
    
    init(collectionId: String, networkClient: NetworkClient) {
        self.collectionId = collectionId
        self.networkClient = networkClient
    }
    
    func requestCollection() {
        let request = CollectionRequestGet(id: collectionId)
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.networkClient.send(request: request, type: NFTCollectionResponce.self) { (result: Result<NFTCollectionResponce, Error>) in
                switch result {
                case .success(let collection):
                    DispatchQueue.main.async {
                        self.nftCollectionSubject.send([collection])
                    }
                    self.requestNfts(collection.nfts)
                case .failure(let error):
                    self.nftCollectionSubject.send([])
                    print("failed collection: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getViewModelForCellAt(_ indexPath: IndexPath) -> CollectionDetailsCellViewModel {
        return nftsSubject.value[indexPath.row]
    }
    
    func downloadImageFor(_ imageView: UIImageView) {
        guard !nftCollectionSubject.value.isEmpty else { return }
        imageView.kf.setImage(
            with:
                URL(string: nftCollectionSubject.value[0].cover
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                )
        )
    }
    
    func getViewModelForWebView(with url: URL) -> WebViewViewModelProtocol {
        WebViewViewModel(url: url)
    }
    
    func getNftsCount() -> Int {
        nftsSubject.value.count
    }
    
    func didSwipeRight() {
        finish?()
    }
    
    func didTapAuthorLink(with url: URL) {
        headForAbout?(url.absoluteString)
    }
    
    private func requestNfts(_ ids: [String]) {
        ids.forEach { [weak self] in
            guard let self else { return }
            
            let request = NftGetRequest(id: $0)
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                
                self.networkClient.send(request: request, type: NftResponseModel.self, onResponse: { (result: Result<NftResponseModel, Error>) in
                    switch result {
                    case .success(let nft):
                        DispatchQueue.main.async {
                            self.nftsSubject.value.append(
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
