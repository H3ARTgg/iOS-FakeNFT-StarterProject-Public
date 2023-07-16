import UIKit

// MARK: - Protocols
protocol CartViewControllerDelegate: AnyObject {
    func getQuantityNfts() -> Int
    func getTotalPrice() -> Double
    func openDeleteNftViewController(_ nft: Nft?)
    func openPaymentViewController()
    func reloadTableView()
}

final class CartViewController: UIViewController {
    // MARK: - Properties
    let customView = CartView()

    private var cartViewModel: CartViewModelProtocol
    
    weak var updateDelegate: UpdateCartViewDelegate?
    
    // MARK: - Lifecycle
    init(cartViewModel: CartViewModelProtocol) {
        self.cartViewModel = cartViewModel
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: Consts.LocalizedStrings.cart,
                                       image: Consts.Images.cart,
                                       tag: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        customView.configure(delegate: self)
        updateDelegate = customView
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        
        if cartViewModel.isLoadCompleted {
            updateDelegate?.reloadTableView()
            updateDelegate?.refreshPayment()
        } else {
            UIProgressHUD.show()
        }
        
        cartViewModel.bind(updateViewController: { [weak self] _ in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.updateDelegate?.reloadTableView()
                    self.updateDelegate?.refreshPayment()
                    self.customView.showScenario(from: self.cartViewModel.listProducts.isEmpty)
                    UIProgressHUD.dismiss()
                }
        })
        
        customView.showScenario(from: cartViewModel.listProducts.isEmpty)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    @objc func openSortAlert() {
        cartViewModel.showSortAlert()
    }
}

// MARK: - Private methods
extension CartViewController {
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Asset.Assets.sortButton.image,
            style: .done,
            target: self,
            action: #selector(openSortAlert)
        )
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartViewModel.listProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Consts.Cart.CellIdentifier.productCartCellIdentifier, for: indexPath
        ) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        let nft = cartViewModel.listProducts[indexPath.row]
        
        cell.delegate = self
        cell.configure(nft)
        
        return cell
    }
}

// MARK: - CartViewControllerDelegate
extension CartViewController: CartViewControllerDelegate {
    func getQuantityNfts() -> Int {
        return cartViewModel.listProducts.count
    }
    
    func getTotalPrice() -> Double {
        var total: Double = 0
        
        for item in cartViewModel.listProducts {
            let price = item.price
            total += price
        }
        
        return total
    }
    
    func openDeleteNftViewController(_ nft: Nft?) {
        guard let nft else { return }
        cartViewModel.openDeleteNft(nft: nft)
    }
    
    func openPaymentViewController() {
        cartViewModel.openPaymnetView()
    }
    
    func reloadTableView() {
        updateDelegate?.reloadTableView()
    }
}
