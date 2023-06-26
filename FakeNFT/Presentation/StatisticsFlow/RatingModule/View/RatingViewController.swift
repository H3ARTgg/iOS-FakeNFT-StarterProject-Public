import UIKit
import ProgressHUD

/// Контроллер  отвечает за отображение списка пользователей
final class RatingViewController: UIViewController {
    
    // MARK: Private properties
    private var viewModel: RatingViewModelProtocol
    private lazy var refreshControl = makeRefreshControll()
    
    // MARK: UI
    private lazy var ratingTableView = makeRatingTableView()
    
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
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkUsers()
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
}

extension RatingViewController {
    func makeRatingTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        return tableView
    }
    
    func makeRefreshControll() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }
    
    func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        navigationItem.title = ""
    }
    
    func  navigationItemSetup() {
        let filterButton = UIBarButtonItem(
            image: Consts.Images.sortIcon.withTintColor(Asset.Colors.ypBlack.color, renderingMode: .alwaysTemplate),
            style: .done,
            target: self,
            action: #selector(sortedButtonTapped))
        navigationItem.rightBarButtonItem = filterButton
        navigationController?.navigationBar.tintColor = Asset.Colors.ypBlack.color
    }
    
    func addViews() {
        view.addSubview(ratingTableView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            ratingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Consts.Statistic.topConstant),
            ratingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Consts.Statistic.sideConstant),
            ratingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Consts.Statistic.sideConstant),
            ratingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func bind() {
        viewModel.updateViewData = { [weak self] _ in
            guard let self else { return }
            self.ratingTableView.reloadData()
        }
        
        viewModel.headForAlert = { [weak self] alertModel in
            guard let self else { return }
            self.presentActionSheet(alertModel: alertModel)
        }
        
        viewModel.addUsers = { [weak self] value in
            guard let self else { return }
            if value.oldValue != value.newValue {
                self.ratingTableView.performBatchUpdates {
                    let indexPath = (value.oldValue..<value.newValue).map { IndexPath(row: $0, section: 0)}
                    self.ratingTableView.insertRows(at: indexPath, with: .automatic)
                }
            }
        }
        
        viewModel.hideTableView = { [weak self] _ in
            ProgressHUD.show()
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                self.ratingTableView.alpha = 0
            }
        }
        
        viewModel.showTableView = { [weak self] _ in
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                self.ratingTableView.alpha = 1
            }
            ProgressHUD.dismiss()
        }
    }
    
    @objc
    func sortedButtonTapped() {
        viewModel.showActionSheep()
    }
    
    @objc
    func refresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            self.viewModel.updateUsers()
            sender.endRefreshing()
        }
    }
    
    func presentActionSheet(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.alertText, message: nil, preferredStyle: .actionSheet)
        alertModel.alertActions.forEach { alertAction in
            let actionStyle: UIAlertAction.Style
            switch alertAction.actionRole {
            case .destructive: actionStyle = .destructive
            case .regular: actionStyle = .default
            case .cancel: actionStyle = .cancel
            }
            
            let action = UIAlertAction(
                title: alertAction.actionText,
                style: actionStyle,
                handler: { _ in alertAction.action?() }
            )
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
}

// MARK: UITableViewDelegate
extension RatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.countUsers-1 {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.viewModel.fetchUsers()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userCardViewModel = viewModel.viewModelForUserCard(at: indexPath.row)
        let viewController = UserCardViewController(viewModel: userCardViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: UITableViewDataSource
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
        Consts.Statistic.heightUserTableViewCell
    }
}
