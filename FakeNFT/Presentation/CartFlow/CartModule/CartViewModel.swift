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
    
    private let storageManager: StorageManager
    private var cartNetworkService: CartNetworkServiceProtocol
    
    private var isInitialLoadCompleted = false
    
    init(
        storageManager: StorageManager = StorageManager.shared,
        cartNetworkService: CartNetworkServiceProtocol
    ) {
        self.storageManager = storageManager
        self.cartNetworkService = cartNetworkService
        fetchProducts()
    }
    
    private func fetchProducts() {
        cartNetworkService.fetchProducts { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.products = products
                    
                    if products.isEmpty {
                        self.storageManager.sortOption = .none
                    }
                    
                    if self.storageManager.sortOption != .none {
                        switch self.storageManager.sortOption {
                        case .sortPrice:
                            self.sortFromPrice()
                        case .sortRating:
                            self.sortFromRating()
                        case .sortTitle:
                            self.sortFromTitle()
                        default: break
                        }
                    }
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

// MARK: - Private methods
extension CartViewModel {
    private func sortWith(_ comparator: (Nft, Nft) -> Bool, option: SortOption) {
        products.sort(by: comparator)
        storageManager.sortOption = option
    }
    
    private func sortFromPrice() {
        sortWith({ $0.price < $1.price }, option: .sortPrice)
    }

    private func sortFromRating() {
        sortWith({ $0.rating > $1.rating }, option: .sortRating)
    }

    private func sortFromTitle() {
        sortWith({ $0.name < $1.name }, option: .sortTitle)
    }
    
    private func createSortAlertModel() -> AlertModel {
        let alertTitle = L10n.Sort.catalogue
        let sortPriceActionTitle = L10n.Sort.price
        let sortRatingActionTitle = L10n.Sort.rating
        let sortTitleActionTitle = L10n.Sort.title
        let cancelActionTitle = L10n.CancelAction.text
        
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
