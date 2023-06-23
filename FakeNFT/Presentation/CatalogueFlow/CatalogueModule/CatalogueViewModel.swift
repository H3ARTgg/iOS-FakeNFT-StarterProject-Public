import Foundation

final class CatalogueViewModel {
    @Observable private(set) var nftCollections: [CatalogueSupplementaryViewModel] = []
    
    init() {
        requestCollections()
    }
    
    private func requestCollections() {
        // Работа с сетевым клиентом
        let nftCollectionsResponse = [
            NFTCollection(
                createdAt: "2023-04-20T02:22:27Z",
                name: "Beige_2",
                cover: "https://static.mk.ru/upload/entities/2019/09/03/10/articles/facebookPicture/18/2d/74/74/fbaa67758a00d75d858f26647f16f843.jpg",
                nfts: ["1", "2", "3"],
                description: "",
                author: "Some",
                id: "1"),
            NFTCollection(
                createdAt: "2023-04-20T02:22:27Z",
                name: "Beige_1",
                cover: "https://n1s1.hsmedia.ru/a1/ec/ec/a1ececc48afd3c0c498fdbd47ba45dbe/728x542_1_f5b22481fc08917ff7584d523f52ed21@1000x745_0xac120003_3944844451633381523.jpeg",
                nfts: ["4", "5", "6", "7"],
                description: "",
                author: "Some",
                id: "2"),
            NFTCollection(
                createdAt: "2023-04-20T02:22:27Z",
                name: "Beige_1",
                cover: "https://n1s1.hsmedia.ru/a1/ec/ec/a1ececc48afd3c0c498fdbd47ba45dbe/728x542_1_f5b22481fc08917ff7584d523f52ed21@1000x745_0xac120003_3944844451633381523.jpeg",
                nfts: ["4", "5", "6", "7"],
                description: "",
                author: "Some",
                id: "2"),
            NFTCollection(
                createdAt: "2023-04-20T02:22:27Z",
                name: "Beige_1",
                cover: "https://n1s1.hsmedia.ru/a1/ec/ec/a1ececc48afd3c0c498fdbd47ba45dbe/728x542_1_f5b22481fc08917ff7584d523f52ed21@1000x745_0xac120003_3944844451633381523.jpeg",
                nfts: ["4", "5", "6", "7"],
                description: "",
                author: "Some",
                id: "2"),
            NFTCollection(
                createdAt: "2023-04-20T02:22:27Z",
                name: "Beige_1",
                cover: "https://n1s1.hsmedia.ru/a1/ec/ec/a1ececc48afd3c0c498fdbd47ba45dbe/728x542_1_f5b22481fc08917ff7584d523f52ed21@1000x745_0xac120003_3944844451633381523.jpeg",
                nfts: ["4", "5", "6", "7"],
                description: "",
                author: "Some",
                id: "2")
        ]
        
        nftCollectionsResponse.forEach {
            let collection = CatalogueSupplementaryViewModel(
                name: $0.name + " (\($0.nfts.count))",
                nftCount: $0.nfts.count,
                cell: CatalogueCellViewModel(imageURL: $0.cover)
            )
            nftCollections.append(collection)
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
