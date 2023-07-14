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
