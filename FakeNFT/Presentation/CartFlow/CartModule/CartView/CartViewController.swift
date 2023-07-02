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
    private var viewModel: CartViewModelProtocol
    
    weak var updateDelegate: UpdateCartViewDelegate?
    
    // MARK: - Lifecycle
    init(viewModel: CartViewModelProtocol = CartViewModel()) {
        self.viewModel = viewModel
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
        
        let customView = CartView()
        customView.configure(delegate: self)
        updateDelegate = customView
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        
        if viewModel.isLoadCompleted {
            updateDelegate?.reloadTableView()
            updateDelegate?.refreshPayment()
        } else {
            UIBlockingProgressHUD.show()
        }
        
        viewModel.bind(callback: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.updateDelegate?.reloadTableView()
                    self.updateDelegate?.refreshPayment()
                    UIBlockingProgressHUD.dismiss()
                }
        })
    }
    
    // MARK: - Actions
    @objc func openSortAlert() {
        showAlert()
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
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Сортировка", message: nil, preferredStyle: .actionSheet
        )
        
        let priceFilter = UIAlertAction(
            title: "По цене", style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.sortFromPrice()
        }
        
        let ratingFilter = UIAlertAction(
            title: "По рейтингу", style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.sortFromRating()
        }
        
        let titleFilter = UIAlertAction(
            title: "По названию", style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.sortFromTitle()
        }
        
        let closeAction = UIAlertAction(
            title: "Закрыть", style: .cancel
        )
        
        alert.addAction(priceFilter)
        alert.addAction(ratingFilter)
        alert.addAction(titleFilter)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.listProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Consts.Cart.cartCellIdentifier, for: indexPath
        ) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        let nft = viewModel.listProducts[indexPath.row]
        
        cell.delegate = self
        cell.configure(nft)
        
        return cell
    }
}

// MARK: - CartViewControllerDelegate
extension CartViewController: CartViewControllerDelegate {
    func getQuantityNfts() -> Int {
        return viewModel.listProducts.count
    }
    
    func getTotalPrice() -> Double {
        var total: Double = 0
        
        for item in viewModel.listProducts {
            let price = item.price
            total += price
        }
        
        return total
    }
    
    func openDeleteNftViewController(_ nft: Nft?) {
        let deleteNftVC = DeleteNftViewController(viewModel: viewModel)
        deleteNftVC.nft = nft
        deleteNftVC.modalPresentationStyle = .overFullScreen
        present(deleteNftVC, animated: true)
    }
    
    func openPaymentViewController() {
        let paymentVC = PaymentViewController()
        navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    func reloadTableView() {
        updateDelegate?.reloadTableView()
    }
}
