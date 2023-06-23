import UIKit
import SnapKit
import ProgressHUD

final class CatalogueViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CatalogueCell.self)
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CatalogueSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        collectionView.backgroundColor = Asset.Colors.ypWhite.color
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var sortButton: UIButton = {
        let button = UIButton.systemButton(with: Consts.Images.sortButtonCatalogue, target: self, action: #selector(didTapSortButton))
        button.setTitle(nil, for: .normal)
        button.tintColor = Asset.Colors.ypBlack.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    private var viewModel: CatalogueViewModel?
    
    init(viewModel: CatalogueViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.tabBarItem = UITabBarItem(title: Consts.LocalizedStrings.catalogue,
                                       image: Consts.Images.catalogue,
                                       tag: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.ypWhite.color
        collectionView.addSubview(refreshControl)
        setupLayout()
        
        viewModel?.$nftCollections.bind(action: { [weak self] _ in
            self?.collectionView.reloadData()
            ProgressHUD.remove()
        })
        
        if let check = viewModel?.nftCollections.isEmpty {
            if check {
                ProgressHUD.show()
            }
        }
    }
    
    @objc
    private func didTapSortButton() {
        setupAlert()
    }
    
    @objc
    private func refresh() {
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func presentCollectionDetailsViewController(at indexPath: IndexPath) {
        let collectionDetailsVC = CollectionDetailsViewController(viewModel: CollectionDetailsViewModel())
        present(collectionDetailsVC, animated: true)
    }
}

// MARK: - Views
private extension CatalogueViewController {
    private func setupLayout() {
        [collectionView, sortButton].forEach {
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setupAlert() {
        let alert = UIAlertController(title: "", message: Consts.LocalizedStrings.sortingCatalogueMessage, preferredStyle: .actionSheet)
        let sortByName = UIAlertAction(title: Consts.LocalizedStrings.byName, style: .default) { [weak self] _ in
            self?.viewModel?.sortByName()
        }
        let sortByNftsCount = UIAlertAction(title: Consts.LocalizedStrings.byNftCount, style: .default) { [ weak self] _ in
            self?.viewModel?.sortByNftCount()
        }
        let cancelAction = UIAlertAction(title: Consts.LocalizedStrings.close, style: .cancel)
        
        alert.addAction(sortByName)
        alert.addAction(sortByNftsCount)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - DataSource
extension CatalogueViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.nftCollections.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogueCell.defaultReuseIdentifier, for: indexPath) as? CatalogueCell else {
            return UICollectionViewCell()
        }
        
        viewModel?.configure(cell, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "Header"
        case UICollectionView.elementKindSectionFooter:
            id = "Footer"
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? CatalogueSupplementaryView else {
            assertionFailure("No SupplementaryView")
            return UICollectionReusableView(frame: .zero)
        }
        viewModel?.configure(view, for: indexPath)
        return view
    }
}

// MARK: - DelegateFlowLayout
extension CatalogueViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentCollectionDetailsViewController(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let footerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath)

        return footerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
