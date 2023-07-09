import Foundation

protocol CartViewModelProtocol {
    var listProducts: [Nft] { get }
    var isLoadCompleted: Bool { get }
    func sortFromPrice()
    func sortFromRating()
    func sortFromTitle()
    func delete(from id: Int)
    func bind(updateViewController: @escaping ([Nft]) -> Void)
}

final class CartViewModel: ObservableObject {
    @Observable var products: [Nft] = []
    
    private var cartNetworkService: CartNetworkServiceProtocol
    
    private var isInitialLoadCompleted = false
    
    init(cartNetworkService: CartNetworkServiceProtocol = CartNetworkService()) {
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
}

extension CartViewModel: CartViewModelProtocol {
    var listProducts: [Nft] {
        return products
    }

    var isLoadCompleted: Bool {
        return isInitialLoadCompleted
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
            let ids = products.map { String($0.id) }
            cartNetworkService.putProducts(productIds: ids)
        }
    }

    func bind(updateViewController: @escaping ([Nft]) -> Void) {
        $products.bind(action: updateViewController)
    }
}