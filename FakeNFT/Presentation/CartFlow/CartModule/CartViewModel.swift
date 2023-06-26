import Foundation

final class CartViewModel: ObservableObject {
    @Observable var products: [Nft] = []
    
    private var idProducts: [String] = []
    private var cartNetworkService: CartNetworkService
    
    var isInitialLoadCompleted = false
    
    init(cartNetworkService: CartNetworkService = CartNetworkService()) {
        self.cartNetworkService = cartNetworkService
        fetchProducts()
    }
    
    private func fetchProducts() {
        cartNetworkService.fetchProducts { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.products = products
                    self.isInitialLoadCompleted = true
                case .failure(let error):
                    print(error.localizedDescription)
                }
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
    
    func delete(from id: Int) {
        if let index = products.firstIndex(where: { $0.id == id }) {
            products.remove(at: index)
        }
    }
}
