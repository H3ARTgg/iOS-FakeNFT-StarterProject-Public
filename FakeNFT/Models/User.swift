import Foundation

struct User {
    let name: String
    let secondName: String
    let description: String
    let photo: String
    let website: String
    let nftCollection: [Any]?
    var nftCollectionCount: Int {
        nftCollection?.count ?? 0
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.secondName == rhs.secondName &&
            lhs.photo == rhs.photo 
    }
}

// HARDCODE перенести в моковый сервис для тестов
extension User {
    static let users = [
        User(name: "Alex", secondName: "Alexov", description: "Cool man", photo: "Alex", website: "WWW", nftCollection: nil),
        User(name: "Bill", secondName: "Billov", description: "Not bad man", photo: "No_photo", website: "WWW", nftCollection: nil),
        User(name: "Alla", secondName: "Allova", description: "Cool girl", photo: "No_photo", website: "WWW", nftCollection: nil),
        User(name: "Mads", secondName: "Madsov", description: "Not very bad man", photo: "Mads", website: "WWW", nftCollection: nil),
        User(name: "Timothèe", secondName: "Timofeev", description: "bad man", photo: "Timothee", website: "WWW", nftCollection: nil),
        User(name: "Lea", secondName: "Leanovna", description: "Not dat girl", photo: "Lea", website: "WWW", nftCollection: nil),
        User(name: "Eric", secondName: "Cartman", description: "I'm not eric cartman from South park 😡", photo: "Eric", website: "WWW", nftCollection: nil)
    ]
}
