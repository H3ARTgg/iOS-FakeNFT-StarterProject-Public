import UIKit
import ProgressHUD

final class UserCollectionViewController: UIViewController {
    
    // MARK: private properties
    private var viewModel: UserCollectionViewModelProtocol
    private lazy var refreshControl = makeRefreshControll()
    
    // MARK: UI
    private lazy var collectionView = makeCollectionView()
    private lazy var plugLabel = makePlugLabel()
    
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
        return collectionView
    }
    
    func makePlugLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Asset.Colors.ypBlack.color
        label.textAlignment = .center
        label.font = Consts.Fonts.bold22
        label.isHidden = true
        return label
    }
    
    func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        title = Consts.LocalizedStrings.userCollectionViewControllerTitle
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
        viewModel.updateViewData = { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.collectionView.reloadData()
            }
        }
        
        viewModel.hideCollectionView = { [weak self] _ in
            ProgressHUD.show()
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                self.collectionView.alpha = 0
            }
        }
        
        viewModel.showCollectionView = { [weak self] _ in
            UIView.animate(withDuration: 0.3) { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.collectionView.alpha = 1
                }
            }
            ProgressHUD.dismiss()
        }
        
        viewModel.showPlugView = { [weak self] text in
            guard let self else { return }
            self.plugLabel.text = text
            self.plugLabel.isHidden = false
        }
    }
    
    func makeRefreshControll() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
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
        let heightConstant = bounds.height / 4.229
        let size = CGSize(width: width, height: heightConstant)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}
