import UIKit
import Combine
import ProgressHUD

final class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModelProtocol
    
    private lazy var dataSource = ProfileDataSource(tableView: tableView)
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var profileView = ProfileView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.backgroundColor = Asset.Colors.ypWhite.color
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        let rightBarButtonItem = UIBarButtonItem(image: Consts.Images.editBold,
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(showEditProfile))
        
        rightBarButtonItem.tintColor = Asset.Colors.ypBlack.color
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configure()
        applyLayout()
        tableView.dataSource = dataSource
        setupNavBar()
        setupBindings()
        viewModel.requestProfile()
    }
}

// MARK: - TableView Delegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: viewModel.ownedNftsTapped()
        case 1: viewModel.favoritesNftsTapped()
        case 2: viewModel.aboutTapped()
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private Methods

private extension ProfileViewController {
    func setupBindings() {
        guard let profileDataPublisher = viewModel.profileDataPublisher else { return }
        profileDataPublisher.sink(
            receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.setupBindings()
                }
            },
            
            receiveValue: { [weak self] profileData in
                ProgressHUD.dismiss()
                self?.profileView.profileModel = profileData
                guard let profileData else { return }
                
                self?.dataSource.reload([
                    ProfileCellModel(
                        text: L10n.Profile.owned,
                        amount: profileData.ownedNft.count
                    ),
                    ProfileCellModel(
                        text: L10n.Profile.favorite,
                        amount: profileData.favoriteNft.count
                    ),
                    ProfileCellModel(
                        text: L10n.Profile.developer,
                        amount: nil
                    )
                ])
            }
        )
        .store(in: &cancellables)
        
        viewModel.showLoading
            .sink { [weak self] isVisible in
                self?.displayLoading(isVisible)
            }
            .store(in: &cancellables)
    }

    @objc
    func showEditProfile() {
        viewModel.editProfileTapped()
    }
    
    func setupNavBar() {
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButtonItem.tintColor = Asset.Colors.ypBlack.color
        navigationItem.backBarButtonItem = backButtonItem
    }
}

// MARK: - Subviews configure + layout

private extension ProfileViewController {
    func addSubviews() {
        view.addSubview(profileView)
        view.addSubview(tableView)
    }
    
    func configure() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 44),
            tableView.heightAnchor.constraint(equalToConstant: 162),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
