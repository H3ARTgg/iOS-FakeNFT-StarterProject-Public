import UIKit

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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            userSiteButton.layer.borderColor = Asset.Colors.ypWhiteUniversal.color.cgColor
        }
        
        if traitCollection.userInterfaceStyle == .light {
            userSiteButton.layer.borderColor = Asset.Colors.ypBlackUniversal.color.cgColor
        }
    }
}

extension UserCardViewController {
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
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.text = "Joaquin Phoenix"
        return label
    }
    
    func makeDescriptionLabel() -> UILabel {
        let label = makeLabel()
        label.font = UIFont.caption2
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.text = """
        Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт  к коллаборациям.
        """
        return label
    }
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Asset.Colors.ypBlack.color
        label.font = UIFont.caption2
        return label
    }
    
    func makeUserSiteButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showUserSiteButtonTapped), for: .touchUpInside)
        button.setTitle(Consts.LocalizedStrings.userSiteButtonTitle, for: .normal)
        button.setTitleColor(Asset.Colors.ypBlack.color, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.caption1
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        return button
    }
    
    func makeUserCollectionButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showUserCollectionButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.bodyBold
        button.setTitleColor(Asset.Colors.ypBlack.color, for: .normal)
        button.setTitle("Коллекция NFT (112)", for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return button
    }
    
    func makeChevronForwardImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.Assets.chevronForward.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }
    
    func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
    }
    
    func addViews() {
        view.addSubview(stackView)
        [
            userStackView, descriptionLabel, userSiteButton, userCollectionButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [
            avatarImageView, userNameLabel
        ].forEach {
            userStackView.addArrangedSubview($0)
        }
        
        userCollectionButton.addSubview(chevronForwardImageView)
    }
    
    func activateConstraints() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        let userCollectionButtonHeight = screenHeight / 12
        let userSiteButtonHeight = screenHeight / 20
        
        let avatarWidth = screenWidth / 5.4
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Consts.Statistic.sideConstant),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Consts.Statistic.sideConstant),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarWidth),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            userCollectionButton.heightAnchor.constraint(equalToConstant: userCollectionButtonHeight),
            userSiteButton.heightAnchor.constraint(equalToConstant: userSiteButtonHeight),
            
            chevronForwardImageView.centerYAnchor.constraint(equalTo: userCollectionButton.centerYAnchor),
            chevronForwardImageView.rightAnchor.constraint(equalTo: userCollectionButton.rightAnchor)
        ])
    }
    
    @objc
    func showUserSiteButtonTapped() {
        // TODO: make webView
    }
    
    @objc
    func showUserCollectionButtonTapped() {
        // TODO: make userCollection
    }
    
}
