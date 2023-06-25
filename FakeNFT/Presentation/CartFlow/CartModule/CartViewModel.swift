import Foundation

final class CartViewModel: ObservableObject {
    @Observable var products: [Nft] = []
    
    private var idProducts: [String] = []
    private var cartNetworkService: CartNetworkService
    
    init(cartNetworkService: CartNetworkService = CartNetworkService()) {
        self.cartNetworkService = cartNetworkService
        fetchProducts()
    }
    
    private func fetchProducts() {
        cartNetworkService.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sortFromPrice() {
        products.sort { $0.price < $1.price }
    }
    
    func sortFromRating() {
        products.sort { $0.rating > $1.rating }
    }
    
    func sortFromTitle() {
        products.sort { $0.name < $1.name }
    }
}
