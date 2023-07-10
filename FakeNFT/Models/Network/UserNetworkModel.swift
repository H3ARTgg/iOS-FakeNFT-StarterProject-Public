struct UserNetworkModel: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]?
    let rating: String
    let id: String
    
    var intUserRating: Int {
        Int(rating) ?? 0
    }
}

extension UserNetworkModel: Equatable {
    static func > (lhs: UserNetworkModel, rhs: UserNetworkModel) -> Bool {
        return
            lhs.name > rhs.name
    }
    
    static func < (lhs: UserNetworkModel, rhs: UserNetworkModel) -> Bool {
        return
            lhs.name < rhs.name
    }
    
    static func == (lhs: UserNetworkModel, rhs: UserNetworkModel) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.rating == rhs.rating
    }
}

// HARDCODE перенести в моковый сервис для тестов
extension UserNetworkModel {
    static let mockUsers = [
        UserNetworkModel(name: "Alex", avatar: "Alex", description: "Cool man", website: "WWW", nfts: ["1", "2"], rating: "4", id: "1"),
        UserNetworkModel(name: "Bill", avatar: "No_photo", description: "Not bad man", website: "WWW", nfts: ["1", "4"], rating: "2", id: "2"),
        UserNetworkModel(name: "Alla", avatar: "No_photo", description: "Cool girl", website: "WWW", nfts: ["1", "2"], rating: "3", id: "3"),
        UserNetworkModel(name: "Mads", avatar: "Mads", description: "Not very bad man", website: "WWW", nfts: ["1", "2", "3", "1"], rating: "1", id: "4")
    ]
}
