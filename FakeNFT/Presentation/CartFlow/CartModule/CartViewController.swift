import UIKit

final class CartViewController: UIViewController {
    
    private let paymentView = PaymentView()
    
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
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init() {
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
    }
    
    @objc func openSortAlert() {
        print("alert sort")
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
        2
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
        
        cell.configure()
        
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    
}
