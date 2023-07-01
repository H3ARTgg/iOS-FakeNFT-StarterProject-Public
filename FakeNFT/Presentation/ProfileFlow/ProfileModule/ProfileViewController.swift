import UIKit
import Combine

final class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModelProtocol
    private lazy var dataSource = ProfileDiffableDataSource(tableView: tableView)
    private var cancellables: Set<AnyCancellable> = []
    private lazy var profileView = ProfileView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.backgroundColor = Asset.Colors.ypWhite.color
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        return tableView
    }()
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: Consts.LocalizedStrings.profile,
                                       image: Consts.Images.profile,
                                       tag: 0)
        
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
        setupBindings()
        viewModel.viewDidLoad()
    }
}

// MARK: - TableView Delegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
}

// MARK: - Private Methods

private extension ProfileViewController {
    func setupBindings() {
        viewModel.profileData.sink { [weak self] profileData in
            self?.profileView.profileModel = profileData
            guard let profileData else { return }
            self?.dataSource.reload([ProfileCellModel(text: Consts.LocalizedStrings.ownedNfts,
                                                      amount: profileData.ownedNft),
                                     ProfileCellModel(text: Consts.LocalizedStrings.favoriteNfts,
                                                      amount: profileData.favouriteNft),
                                     ProfileCellModel(text: Consts.LocalizedStrings.aboutDeveloper,
                                                      amount: nil)])
        }
        .store(in: &cancellables)
    }
    
    @objc
    func showEditProfile() {
        guard let profileData = viewModel.profileData.value else { return }
        let profileEditUserViewModel = ProfileEditUserViewModel(imageUrl: profileData.imageUrl,
                                                                name: profileData.name,
                                                                description: profileData.about,
                                                                website: profileData.site)
        
        let profileEditViewModel = ProfileEditViewModel(profile: profileEditUserViewModel,
                                                        saveCallback: viewModel.setProfile(_:))
        
        present(ProfileEditTableView(viewModel: profileEditViewModel), animated: true)
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
