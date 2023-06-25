import UIKit

/// ячейка user
final class UserTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: Helper
    static var defaultReuseIdentifier: String { "UserCell" }
    
    private struct CellConstants {
        static let userViewWidth = (UIScreen.main.bounds.width - Consts.Statistic.sideConstant * 2) / 1.1111
        static let positionInRatingLabelHeight: CGFloat = 20
        static let edgeDistance: CGFloat = 4
        static let stackViewCornerRadius: CGFloat = 12
    }
    
    // MARK: Private properties
    private var viewModel: UserTableViewCellViewModelProtocol?
    
    // MARK: UI
    private lazy var positionInRatingLabel = makePositionInRatingLabel()
    private lazy var userView = UserView()
    
    // MARK: initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addSubview()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    public func initialize(viewModel: UserTableViewCellViewModelProtocol?) {
        self.viewModel = viewModel
        userView.initialize(viewModel: viewModel?.getViewModelForUserView())
        bind()
    }
    
    // MARK: Override
    override func prepareForReuse() {
        super.prepareForReuse()
        positionInRatingLabel.text = nil
    }
}

extension UserTableViewCell {
    func makePositionInRatingLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Asset.Colors.ypBlack.color
        label.font = UIFont.caption1
        label.textAlignment = .center
        return label
    }
    
    func bind() {
        guard let viewModel else { return }
        positionInRatingLabel.text = viewModel.positionInRating
    }
    
    func setupView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    func addSubview() {
        [positionInRatingLabel, userView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            positionInRatingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            positionInRatingLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            positionInRatingLabel.rightAnchor.constraint(equalTo: userView.leftAnchor),
            positionInRatingLabel.heightAnchor.constraint(equalToConstant: CellConstants.positionInRatingLabelHeight),
            
            userView.widthAnchor.constraint(equalToConstant: CellConstants.userViewWidth),
            userView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellConstants.edgeDistance),
            userView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CellConstants.edgeDistance),
            userView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
