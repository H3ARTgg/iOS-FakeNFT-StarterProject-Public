import UIKit
import ProgressHUD

final class UserCollectionViewController: UIViewController {
    
    // MARK: private properties
    private var viewModel: UserCollectionViewModelProtocol
    private lazy var refreshControl = makeRefreshControll()
    
    // MARK: UI
    private lazy var collectionView = makeCollectionView()
    private lazy var plugLabel = PlugLabel()
    
    // MARK: Initialization
    init(viewModel: UserCollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        viewSetup()
        activateConstraints()
        bind()
        viewModel.fetchNft()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIBlockingProgressHUD.dismiss()
    }
}

private extension UserCollectionViewController {
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(NftViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.refreshControl = refreshControl
        collectionView.alpha = 0
        return collectionView
    }
    
    func makeRefreshControll() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }
    
    func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        title = L10n.Statistic.UserCollectionViewController.title
    }
    
    func addViews() {
        [collectionView, plugLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Consts.Statistic.topConstant).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Consts.Statistic.sideConstant).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Consts.Statistic.sideConstant).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        plugLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        plugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plugLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
    
    func bind() {
        viewModel.showCollectionView = { [weak self] isHidden in
            guard let self else { return }
            DispatchQueue.main.async {
                self.showCollectionView(show: isHidden)
                self.collectionView.reloadData()
            }
        }
        
        viewModel.showPlugView = { [weak self] (isHidden, text) in
            guard let self else { return }
            DispatchQueue.main.async {
                self.plugLabel.isHidden = !isHidden
                self.plugLabel.text = text
            }
        }
        
        viewModel.showProgressHUD = { check in
            check ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
        }
    }
    
    func showCollectionView(show: Bool) {
        UIView.animate(withDuration: 0.3) { [weak collectionView] in
            guard let collectionView else { return }
            collectionView.alpha = show ? 1 : 0
        }
    }
    
    @objc
    func refresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            self.viewModel.refreshNft()
            sender.endRefreshing()
        }
    }
}

extension UserCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.countUsers
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NftViewCell.defaultReuseIdentifier,
                for: indexPath
            ) as? NftViewCell
        else {
            return UICollectionViewCell()
            
        }
        let cellViewModel = viewModel.nftCellViewModel(at: indexPath.row)
        cell.initialize(viewModel: cellViewModel)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension UserCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 42) / 3
        let heightConstant: CGFloat = 192
        let size = CGSize(width: width, height: heightConstant)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Consts.Statistic.minimumSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Consts.Statistic.minimumSpacingForSectionAt
    }
}
