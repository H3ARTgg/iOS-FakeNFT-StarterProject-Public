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
    private lazy var errorButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(), target: self, action: #selector(didTapErrorButton))
        button.setImage(nil, for: .normal)
        button.setTitle(Consts.LocalizedStrings.errorAlertAgain, for: .normal)
        button.setTitleColor(Asset.Colors.ypBlack.color, for: .normal)
        button.titleLabel?.font = Consts.Fonts.bold17
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = Asset.Colors.ypLightGray.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var errorTitle: UILabel = {
        let title = UILabel()
        title.text = Consts.LocalizedStrings.errorConnectionMessage
        title.font = Consts.Fonts.regular17
        title.textColor = Asset.Colors.ypBlack.color
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    private var viewModel: CatalogueViewModel
    
    init(viewModel: CatalogueViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        collectionView.insertSubview(refreshControl, at: 0)
        setupLayout()
        
        viewModel.$nftCollections.bind(action: { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
        
        CustomProgressHUD.show()
        viewModel.$isGotCollections.bind(action: { [weak self] check in
            DispatchQueue.main.async {
                CustomProgressHUD.dismiss()
                if !check {
                    self?.setupErrorContent()
                }
            }
        })
        
        if viewModel.isGotCollections {
            CustomProgressHUD.dismiss()
        } else {
            CustomProgressHUD.dismiss()
            setupErrorContent()
        }
    }
    
    @objc
    private func didTapSortButton() {
        setupAlert()
    }
    
    @objc
    private func didTapErrorButton() {
        removeErrorContent()
        CustomProgressHUD.show()
        viewModel.requestCollections()
    }
    
    @objc
    private func refresh() {
        forceHideRefreshControl(for: collectionView)
        viewModel.requestCollections()
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func forceHideRefreshControl(for collectionView: UICollectionView) {
        if collectionView.contentOffset.y < 0 {
            collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
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
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
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
            self?.viewModel.sortByName()
        }
        let sortByNftsCount = UIAlertAction(title: Consts.LocalizedStrings.byNftCount, style: .default) { [ weak self] _ in
            self?.viewModel.sortByNftCount()
        }
        let cancelAction = UIAlertAction(title: Consts.LocalizedStrings.close, style: .cancel)
        
        alert.addAction(sortByName)
        alert.addAction(sortByNftsCount)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func setupErrorContent() {
        [errorTitle, errorButton].forEach {
            view.addSubview($0)
        }
        
        errorTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        errorButton.snp.makeConstraints { make in
            make.top.equalTo(errorTitle.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(60)
            make.trailing.equalTo(view.snp.trailing).offset(-60)
            make.height.equalTo(35)
            
        }
    }
    
    private func removeErrorContent() {
        errorTitle.removeFromSuperview()
        errorButton.removeFromSuperview()
    }
}

// MARK: - DataSource
extension CatalogueViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.nftCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogueCell.defaultReuseIdentifier, for: indexPath) as? CatalogueCell else {
            return UICollectionViewCell()
        }
        viewModel.configure(cell, for: indexPath)
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
        viewModel.configure(view, for: indexPath)
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
