import UIKit

/// Контроллер  отвечает за отображение списка пользователей
final class RatingViewController: UIViewController {

    // MARK: Private properties
    private var viewModel: RatingViewModelProtocol
    
    // MARK: UI
    private lazy var ratingTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: Initialization
    init(viewModel: RatingViewModelProtocol) {
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
        navigationItemSetup()
        addViews()
        activateConstraints()
    }
}

extension RatingViewController {
    func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
    }
    
    func  navigationItemSetup() {
        let filterButton = UIBarButtonItem(
            image: Consts.Images.sortIcon.withTintColor(Asset.Colors.ypBlack.color, renderingMode: .alwaysTemplate),
            style: .done,
            target: self,
            action: #selector(sortedButtonTapped))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    func addViews() {
        view.addSubview(ratingTableView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            ratingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Consts.topConstant),
            ratingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Consts.sideConstant),
            ratingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Consts.sideConstant),
            ratingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    func sortedButtonTapped() {
        // TODO: Filter
    }
}

extension RatingViewController: UITableViewDelegate {}

extension RatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.countUsers
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? UserTableViewCell else { return UITableViewCell() }
        let cellViewModel = viewModel.viewModelForCell(at: indexPath.row)
        cell.initialize(viewModel: cellViewModel)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Consts.heightUserTableViewCell
    }
}
