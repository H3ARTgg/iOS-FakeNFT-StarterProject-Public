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
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
}

private extension RatingViewController {
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
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }
    
    func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        navigationItem.title = ""
    }
    
    func navigationItemSetup() {
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
        viewModel.headForAlert = { [weak self] alertModel in
            guard let self else { return }
            self.presentActionSheet(alertModel: alertModel)
        }
        
        viewModel.showTableView = { [weak self] check in
            if check {
                self?.showTableView()
            } else {
                self?.hideTableView()
            }
            self?.reloadRatingTableView()
        }
    }
    
    @objc
    func sortedButtonTapped() {
        viewModel.showActionSheet()
    }
    
    @objc
    func refresh(_ sender: UIRefreshControl) {
        ProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            self.viewModel.fetchUsers()
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
    
    func reloadRatingTableView() {
        ratingTableView.reloadData()
        ratingTableView.layoutIfNeeded()
        ratingTableView.setContentOffset(.zero, animated: true)
    }
    
    func hideTableView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.ratingTableView.alpha = 0
        }
    }
    
    func showTableView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.ratingTableView.alpha = 1
        }
        ProgressHUD.dismiss()
    }
}

// MARK: UITableViewDelegate
extension RatingViewController: UITableViewDelegate {
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
        ) as? UserTableViewCell
        else {
            return UITableViewCell()
        }
        let cellViewModel = viewModel.viewModelForCell(at: indexPath.row)
        cell.initialize(viewModel: cellViewModel)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Consts.Statistic.heightUserTableViewCell
    }
}
