final class CollectionDetailsViewModel {
    private var collectionId: String
    private var networkClient: NetworkClient
    
    init(collectionId: String, networkClient: NetworkClient) {
        self.collectionId = collectionId
        self.networkClient = networkClient
    }
}
