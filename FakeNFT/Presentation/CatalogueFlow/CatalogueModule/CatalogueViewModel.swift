import Foundation
import Combine

protocol CatalogueCoordination: AnyObject {
    var headForCollectionDetails: ((String) -> Void)? { get set }
    var headForActionSheet: ((AlertModel) -> Void)? { get set }
}
protocol CatalogueViewModelProtocol: AnyObject {
    var isFailedPublisher: AnyPublisher<Bool, Never> { get }
    var nftCollectionsPublisher: AnyPublisher<[CatalogueSupplementaryViewModel], Never> { get }
    func requestCollections()
    func getViewModelForCell(with indexPath: IndexPath) -> CatalogueCellViewModelProtocol?
    func getViewModelForSupView(with indexPath: IndexPath) -> CatalogueSupplementaryViewModel?
    func sortByName()
    func sortByNftCount()
    func getNftsCount() -> Int
    func didTapCollectionDetailsWith(_ indexPath: IndexPath)
    func didTapSortButton(with alertModel: AlertModel)
}

final class CatalogueViewModel: CatalogueViewModelProtocol, CatalogueCoordination {
    var headForCollectionDetails: ((String) -> Void)?
    var headForActionSheet: ((AlertModel) -> Void)?
    var nftCollectionsPublisher: AnyPublisher<[CatalogueSupplementaryViewModel], Never> {
        nftCollectionsSubject.eraseToAnyPublisher()
    }
    var isFailedPublisher: AnyPublisher<Bool, Never> {
        isFailedSubject.eraseToAnyPublisher()
    }
    private let isFailedSubject = PassthroughSubject<Bool, Never>()
    private let nftCollectionsSubject = CurrentValueSubject<[CatalogueSupplementaryViewModel], Never>([])
    private var networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
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
                self.isFailedSubject.send(false)
            case .failure:
                self.nftCollectionsSubject.send([])
                self.isFailedSubject.send(true)
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
    
    func getNftsCount() -> Int {
        nftCollectionsSubject.value.count
    }
    
    func didTapCollectionDetailsWith(_ indexPath: IndexPath) {
        headForCollectionDetails?(nftCollectionsSubject.value[indexPath.section].id)
    }
    
    func didTapSortButton(with alertModel: AlertModel) {
        headForActionSheet?(alertModel)
    }
}
