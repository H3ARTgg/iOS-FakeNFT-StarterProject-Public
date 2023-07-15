import Foundation

protocol CartCoordination: AnyObject {
    var handleNftSelection: ((Nft, CartViewModel) -> Void)? { get set }
    var handlePaymentScreenOpening: ((CartViewModel) -> Void)? { get set }
    var handleNftDeletion: (() -> Void)? { get set }
    var handleCartScreenReturn: (() -> Void)? { get set }
    var handleForActionSheet: ((AlertModel) -> Void)? { get set }
}

protocol CartViewModelProtocol {
    var listProducts: [Nft] { get }
    var isLoadCompleted: Bool { get }
    func sortFromPrice()
    func sortFromRating()
    func sortFromTitle()
    func delete(from id: Int)
    func updateCart()
    func bind(updateViewController: @escaping ([Nft]) -> Void)
    func showSortAlert()
    func openDeleteNft(nft: Nft)
    func openPaymnetView()
    func closeDeleteNftViewController()
}

final class CartViewModel: ObservableObject, CartCoordination {    
    @Observable var products: [Nft] = []
    
    var handleNftSelection: ((Nft, CartViewModel) -> Void)?
    var handlePaymentScreenOpening: ((CartViewModel) -> Void)?
    var handleNftDeletion: (() -> Void)?
    var handleCartScreenReturn: (() -> Void)?
    var handleForActionSheet: ((AlertModel) -> Void)?
    
    private var cartNetworkService: CartNetworkServiceProtocol
    
    private var isInitialLoadCompleted = false
    
    init(cartNetworkService: CartNetworkServiceProtocol) {
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
                    
                    // Временный метод для проверки, если на сервере нет данных о заказе
                    if products.isEmpty {
                        self.putProducts()
                    } else {
                        self.isInitialLoadCompleted = true
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Временный метод для проверки, если на сервере нет данных о заказе
    private func putProducts() {
        cartNetworkService.putNewProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case true:
                    self?.fetchProducts()
                case false:
                    self?.isInitialLoadCompleted = false
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
            handleNftDeletion?()
        }
    }
    
    func updateCart() {
        products.removeAll()
        cartNetworkService.putProducts(productIds: [])
        handleCartScreenReturn?()
    }

    func bind(updateViewController: @escaping ([Nft]) -> Void) {
        $products.bind(action: updateViewController)
    }
    
    func showSortAlert() {
        let alert = createSortAlertModel()
        handleForActionSheet?(alert)
    }
    
    func openDeleteNft(nft: Nft) {
        handleNftSelection?(nft, self)
    }
    
    func openPaymnetView() {
        handlePaymentScreenOpening?(self)
    }
    
    func closeDeleteNftViewController() {
        handleNftDeletion?()
    }
}

// MARK: - Extension for create alerts
extension CartViewModel {
    private func createSortAlertModel() -> AlertModel {
        let alertTitle = Consts.LocalizedStrings.cartAlertTitle
        let sortPriceActionTitle = Consts.LocalizedStrings.cartSortFromPrice
        let sortRatingActionTitle = Consts.LocalizedStrings.cartSortFromRating
        let sortTitleActionTitle = Consts.LocalizedStrings.cartSortFromTitle
        let cancelActionTitle = Consts.LocalizedStrings.cartCloseAlert
        
        let sortPriceAction = AlertAction(
            actionText: sortPriceActionTitle,
            actionRole: .regular
        ) { [weak self] in
            self?.sortFromPrice()
        }
        
        let sortRatingAction = AlertAction(
            actionText: sortRatingActionTitle,
            actionRole: .regular
        ) { [weak self] in
            self?.sortFromRating()
        }
        
        let sortTitleAction = AlertAction(
            actionText: sortTitleActionTitle,
            actionRole: .regular
        ) { [weak self] in
            self?.sortFromTitle()
        }
        
        let cancelAction = AlertAction(
            actionText: cancelActionTitle,
            actionRole: .cancel,
            action: nil
        )
        
        let alertModel = AlertModel(
            alertText: alertTitle,
            message: nil,
            alertActions: [
                sortPriceAction,
                sortRatingAction,
                sortTitleAction,
                cancelAction
            ]
        )
        
        return alertModel
    }
}
