import UIKit
import Kingfisher

/// Экран отображает информацию о пользователе:
final class UserCardViewController: UIViewController {

    // MARK: Private properties
    private var viewModel: UserCardViewModelProtocol
    
    // MARK: UI
    private lazy var stackView = makeStackView()
    private lazy var userStackView = makeUserStackView()
    private lazy var avatarImageView = makeAvatarImageView()
    private lazy var userNameLabel = makeUserNameLabel()
    private lazy var descriptionLabel = makeDescriptionLabel()
    private lazy var userSiteButton = makeUserSiteButton()
    private lazy var userCollectionButton = makeUserCollectionButton()
    private lazy var chevronForwardImageView = makeChevronForwardImageView()
    
    // MARK: Initialization
    init(viewModel: UserCardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        addViews()
        activateConstraints()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            userSiteButton.layer.borderColor = Asset.Colors.ypBlackUniversal.color.cgColor
        case .dark:
            userSiteButton.layer.borderColor = Asset.Colors.ypWhiteUniversal.color.cgColor
        @unknown default:
            return
        }
    }
}

private extension UserCardViewController {
    private enum TypeViewController {
        case userSite
        case userCollection
    }
    
    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.spacing = 25
        return stackView
    }
    
    func makeUserStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.spacing = 16
        return stackView
    }
    
    func makeAvatarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.image = Asset.Assets.noPhoto.image
        imageView.layer.masksToBounds = true
        return imageView
    }
    
    func makeUserNameLabel() -> UILabel {
        let label = makeLabel()
        label.font = UIFont.headline3
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }
    
    func makeDescriptionLabel() -> UILabel {
        let label = makeLabel()
        label.font = UIFont.caption2
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Asset.Colors.ypBlack.color
        label.font = UIFont.caption2
        label.textAlignment = .natural
        return label
    }
    
    func makeUserSiteButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showUserSiteButtonTapped), for: .touchUpInside)
        button.setTitle(Consts.LocalizedStrings.userSiteButtonTitle, for: .normal)
        button.setTitleColor(Asset.Colors.ypBlack.color, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.caption1
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = Asset.Colors.ypBlack.color.cgColor
        return button
    }
    
    func makeUserCollectionButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showUserCollectionButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.bodyBold
        button.titleLabel?.textAlignment = .natural
        button.setTitleColor(Asset.Colors.ypBlack.color, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }
    
    func makeChevronForwardImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.Assets.chevronForward.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.tintColor = Asset.Colors.ypBlack.color
        return imageView
    }
    
    func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        tabBarController?.tabBar.isHidden = true
        title = ""
    }
    
    func addViews() {
        view.addSubview(stackView)
        
        [userStackView, descriptionLabel, userSiteButton, userCollectionButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [avatarImageView, userNameLabel].forEach {
            userStackView.addArrangedSubview($0)
        }
        
        userCollectionButton.addSubview(chevronForwardImageView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Consts.Statistic.topConstant),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Consts.Statistic.sideConstant),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Consts.Statistic.sideConstant),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: Consts.Statistic.avatarWidth),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            userCollectionButton.heightAnchor.constraint(equalToConstant: Consts.Statistic.userCollectionButtonHeight),
            userSiteButton.heightAnchor.constraint(equalToConstant: Consts.Statistic.userSiteButtonHeight),
            
            chevronForwardImageView.centerYAnchor.constraint(equalTo: userCollectionButton.centerYAnchor),
            chevronForwardImageView.trailingAnchor.constraint(equalTo: userCollectionButton.trailingAnchor)
        ])
    }
    
    func bind() {
        userNameLabel.text = viewModel.userName
        descriptionLabel.text = viewModel.description
        let numberOfSubscribers = viewModel.nfts?.count ?? 0
        let userCollectionButtonTitle = String(
            format: Consts.LocalizedStrings.userCollectionButtonTitle,
            numberOfSubscribers
        )
        userCollectionButton.setTitle(
            userCollectionButtonTitle,
            for: .normal
        )
        loadAvatar()
    }
    
    func loadAvatar() {
        guard let url = viewModel.avatarURL else { return }
        avatarImageView.kf.setImage(with: url)
    }
    
    @objc
    func showUserSiteButtonTapped() {
        viewModel.showUserSiteButtonTapped()
    }
    
    @objc
    func showUserCollectionButtonTapped() {
        viewModel.showUserCollectionButtonTapped()
    }
}
