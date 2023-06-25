import UIKit

protocol CartViewControllerDelegate: AnyObject {
    func getQuantityNfts() -> Int
    func getTotalPrice() -> Double
    func openDeleteNftViewController()
    func openPaymentViewController()
}

final class CartViewController: UIViewController {
    
    private lazy var paymentView = PaymentView(delegate: self)
    
    private lazy var cartTableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(
            CartTableViewCell.self,
            forCellReuseIdentifier: Consts.Cart.cartCellIdentifier
        )
        
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.allowsSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var viewModel: CartViewModel
    
    init(viewModel: CartViewModel = CartViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: Consts.LocalizedStrings.cart,
                                       image: Consts.Images.cart,
                                       tag: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.ypWhite)
        configureNavBar()
        addElements()
        setupConstraints()
        
        viewModel.$products.bind { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
                self.paymentView.refreshData()
            }
        }
    }
    
    @objc func openSortAlert() {
        showAlert()
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(asset: Asset.Assets.sortButton),
            style: .done,
            target: self,
            action: #selector(openSortAlert)
        )
    }
    
    private func addElements() {
        [
            paymentView,
            cartTableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cartTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            cartTableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            cartTableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            
            paymentView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            paymentView.topAnchor.constraint(
                equalTo: cartTableView.bottomAnchor
            ),
            paymentView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            paymentView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Consts.Cart.cartCellIdentifier, for: indexPath
        ) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        let nft = viewModel.products[indexPath.row]
        
        cell.delegate = self
        cell.configure(nft)
        
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    
}

extension CartViewController {
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

extension CartViewController: CartViewControllerDelegate {
    func getQuantityNfts() -> Int {
        return viewModel.products.count
    }
    
    func getTotalPrice() -> Double {
        var total: Double = 0
        
        for item in viewModel.products {
            let price = item.price
            total += price
        }
        
        return total
    }
    
    func openDeleteNftViewController() {
        let deleteNftVC = DeleteNftViewController()
        deleteNftVC.modalPresentationStyle = .fullScreen
        present(deleteNftVC, animated: true)
    }
    
    func openPaymentViewController() {
        let paymentVC = PaymentViewController()
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}
