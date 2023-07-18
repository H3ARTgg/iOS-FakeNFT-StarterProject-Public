import UIKit

protocol UpdateCurrenciesDelegate: AnyObject {
    func updateCollectionView()
}

final class PaymentViewCollection: UIView {
    
    private let paymentView = FinalPaymentView()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(
            CurrencyCollectionViewCell.self,
            forCellWithReuseIdentifier: Consts.Cart.CellIdentifier.currencyCartViewCell
        )
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: PaymentViewControllerDelegate?
    
    func configure(delegate: PaymentViewController) {
        backgroundColor = Asset.Colors.ypWhite.color
        
        self.delegate = delegate
        paymentView.delegate = self.delegate
        collectionView.dataSource = delegate
        collectionView.delegate = delegate
        
        addElements()
        setupConstraints()
    }
    
    private func addElements() {
        [
            collectionView,
            paymentView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor, constant: 20
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: paymentView.topAnchor
            ),
            
            paymentView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            paymentView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            paymentView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )
        ])
    }
}

extension PaymentViewCollection: UpdateCurrenciesDelegate {
    func updateCollectionView() {
        collectionView.reloadData()
    }
}
