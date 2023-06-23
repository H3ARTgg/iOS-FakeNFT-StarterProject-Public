import Foundation

final class CatalogueViewModel {
    @Observable private(set) var nftCollections: [CatalogueSupplementaryViewModel] = []
    @Observable private(set) var isGotCollections: Bool = false
    private var networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        requestCollections()
    }
    
    func requestCollections() {
        let request = CollectionsRequest()
        networkClient.send(request: request, type: [NFTCollection].self) { [weak self] (result: Result<[NFTCollection], Error>) in
            switch result {
            case .success(let collections):
                self?.nftCollections = []
                collections.forEach {
                    let collection = CatalogueSupplementaryViewModel(
                        name: $0.name + " (\($0.nfts.count))",
                        nftCount: $0.nfts.count,
                        cell: CatalogueCellViewModel(imageURL: $0.cover)
                    )
                    self?.nftCollections.append(collection)
                }
                self?.isGotCollections = true
            case .failure(_):
                self?.isGotCollections = false
            }
        }
    }
    
    func configure(_ cell: CatalogueCell, for indexPath: IndexPath) {
        cell.viewModel = nftCollections[indexPath.section].cell
    }
    
    func configure(_ supView: CatalogueSupplementaryView, for indexPath: IndexPath) {
        supView.viewModel = nftCollections[indexPath.section]
    }
    
    func sortByName() {
        nftCollections.sort {
            $0.name < $1.name
        }
    }
    
    func sortByNftCount() {
        nftCollections.sort {
            $0.nftCount < $1.nftCount
        }
    }
}
