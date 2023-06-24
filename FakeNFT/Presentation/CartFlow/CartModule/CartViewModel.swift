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
}
