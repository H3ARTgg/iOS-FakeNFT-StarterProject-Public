import UIKit
import SnapKit
import ProgressHUD
import Combine

protocol CatalogueViewControllerProtocol {
    var viewModel: CatalogueViewModelProtocol { get }
    var isGotCollectionCancellable: AnyCancellable? { get }
    var nftCollectionsCancellable: AnyCancellable? { get }
}

final class CatalogueViewController: UIViewController, CatalogueViewControllerProtocol {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CatalogueCell.self)
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CatalogueSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        collectionView.backgroundColor = Asset.Colors.ypWhite.color
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: Consts.Images.sortButtonCatalogue,
            style: .done,
            target: self,
            action: #selector(didTapSortButton))
        button.title = ""
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
    private(set) var viewModel: CatalogueViewModelProtocol
    private(set) var isGotCollectionCancellable: AnyCancellable?
    private(set) var nftCollectionsCancellable: AnyCancellable?
    
    init(viewModel: CatalogueViewModelProtocol) {
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
        configureViewController()
        addSubviews()
        setupLayouts()
        binds()
        CustomProgressHUD.show()
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
    
    private func configureViewController() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        navigationItem.rightBarButtonItem = sortButton
        navigationController?.navigationBar.tintColor = Asset.Colors.ypBlack.color
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .done,
            target: nil,
            action: nil
        )
    }
    
    private func binds() {
        nftCollectionsCancellable = viewModel.nftCollectionsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.collectionView.reloadData()
            })
        
        isGotCollectionCancellable = viewModel.isGotCollectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] check in
                CustomProgressHUD.dismiss()
                if !check {
                    self?.setupErrorContent()
                }
            }
    }
    
    private func forceHideRefreshControl(for collectionView: UICollectionView) {
        if collectionView.contentOffset.y < 0 {
            collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    private func presentCollectionDetailsViewController(at indexPath: IndexPath) {
        let detailsVM = viewModel.getViewModelForCollectionDetails(with: indexPath)
        let collectionDetailsVC = CollectionDetailsViewController(viewModel: detailsVM)
        navigationController?.pushViewController(collectionDetailsVC, animated: true)
    }
}

// MARK: - Views
private extension CatalogueViewController {
    private func addSubviews() {
        [collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupLayouts() {
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
        viewModel.getNftsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogueCell.defaultReuseIdentifier, for: indexPath) as? CatalogueCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel.getViewModelForCell(with: indexPath)
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
        view.viewModel = viewModel.getViewModelForSupView(with: indexPath)
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
