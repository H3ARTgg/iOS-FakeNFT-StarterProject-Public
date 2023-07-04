import Foundation
import Combine

protocol CatalogueViewModelProtocol {
    var isGotCollectionPublisher: AnyPublisher<Bool, Never> { get }
    var nftCollectionsPublisher: AnyPublisher<[CatalogueSupplementaryViewModel], Never> { get }
    func requestCollections()
    func getViewModelForCell(with indexPath: IndexPath) -> CatalogueCellViewModelProtocol?
    func getViewModelForSupView(with indexPath: IndexPath) -> CatalogueSupplementaryViewModel?
    func getViewModelForCollectionDetails(with indexPath: IndexPath) -> CollectionDetailsViewModel
    func sortByName()
    func sortByNftCount()
    func getNftsCount() -> Int
}

final class CatalogueViewModel: CatalogueViewModelProtocol {
    var nftCollectionsPublisher: AnyPublisher<[CatalogueSupplementaryViewModel], Never> {
        nftCollectionsSubject.eraseToAnyPublisher()
    }
    var isGotCollectionPublisher: AnyPublisher<Bool, Never> {
        isGotCollectionSubject.eraseToAnyPublisher()
    }
    private let isGotCollectionSubject = CurrentValueSubject<Bool, Never>(false)
    private let nftCollectionsSubject = CurrentValueSubject<[CatalogueSupplementaryViewModel], Never>([])
    private var networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        requestCollections()
    }
    
    func requestCollections() {
        let request = CollectionsRequestGet()
        networkClient.send(request: request, type: [NFTCollectionResponce].self) { [weak self] (result: Result<[NFTCollectionResponce], Error>) in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.nftCollectionsSubject.send([])
                collections.forEach {
                    let collection = CatalogueSupplementaryViewModel(
                        id: $0.id,
                        name: $0.name + " (\($0.nfts.count))",
                        nftCount: $0.nfts.count,
                        cell: CatalogueCellViewModel(imageURL: $0.cover)
                    )
                    self.nftCollectionsSubject.value.append(collection)
                }
                self.isGotCollectionSubject.send(true)
            case .failure:
                self.nftCollectionsSubject.send([])
                self.isGotCollectionSubject.send(false)
            }
        }
    }
    
    func getViewModelForCell(with indexPath: IndexPath) -> CatalogueCellViewModelProtocol? {
        guard !nftCollectionsSubject.value.isEmpty else { return nil }
        return nftCollectionsSubject.value[indexPath.section].cell
    }
    
    func getViewModelForSupView(with indexPath: IndexPath) -> CatalogueSupplementaryViewModel? {
        guard !nftCollectionsSubject.value.isEmpty else { return nil }
        return nftCollectionsSubject.value[indexPath.section]
    }
    
    func sortByName() {
        nftCollectionsSubject.value.sort {
            $0.name < $1.name
        }
    }
    
    func sortByNftCount() {
        nftCollectionsSubject.value.sort {
            $0.nftCount < $1.nftCount
        }
    }
    
    func getViewModelForCollectionDetails(with indexPath: IndexPath) -> CollectionDetailsViewModel {
        CollectionDetailsViewModel(collectionId: nftCollectionsSubject.value[indexPath.section].id, networkClient: networkClient)
    }
    
    func getNftsCount() -> Int {
        nftCollectionsSubject.value.count
    }
}
