import UIKit

protocol UpdateCartViewDelegate: AnyObject {
    func reloadTableView()
    func refreshPayment()
}

final class CartView: UIView {
    
    // MARK: - Properties
    private let isEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Cart.cartIsEmpty
        label.font = Consts.Fonts.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentView = PaymentView()
    
    private lazy var cartTableView: UITableView = {
        let table = UITableView()
        table.register(
            CartTableViewCell.self,
            forCellReuseIdentifier: Consts.Cart.CellIdentifier.productCartCellIdentifier
        )
        
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.allowsSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    weak var delegate: CartViewControllerDelegate?
    
    // MARK: - Helpers
    func configure(delegate: CartViewController) {
        self.delegate = delegate
        cartTableView.dataSource = delegate
        paymentView.delegate = delegate
        
        backgroundColor = Asset.Colors.ypWhite.color
        
        addElements()
        setupConstraints()
    }
    
    func showScenario(from state: Bool) {
        if !state {
            isEmptyLabel.isHidden = true
            cartTableView.isHidden = false
            paymentView.isHidden = false
        } else {
            isEmptyLabel.isHidden = false
            cartTableView.isHidden = true
            paymentView.isHidden = true
        }
    }
    
    // MARK: - Private methods
    private func addElements() {
        [
            isEmptyLabel,
            paymentView,
            cartTableView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            isEmptyLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            isEmptyLabel.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            
            cartTableView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            cartTableView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor
            ),
            cartTableView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor
            ),
            
            paymentView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            paymentView.topAnchor.constraint(
                equalTo: cartTableView.bottomAnchor
            ),
            paymentView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            paymentView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}

// MARK: - UpdateCartViewDelegate
extension CartView: UpdateCartViewDelegate {
    func reloadTableView() {
        cartTableView.reloadData()
    }
    
    func refreshPayment() {
        paymentView.refreshData()
    }
}
