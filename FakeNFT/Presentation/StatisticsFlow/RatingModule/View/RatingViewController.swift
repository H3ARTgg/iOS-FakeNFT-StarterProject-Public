import UIKit
import ProgressHUD

/// Контроллер  отвечает за отображение списка пользователей
final class RatingViewController: UIViewController {
    
    // MARK: Private properties
    private var viewModel: RatingViewModelProtocol
    private lazy var refreshControl = makeRefreshControll()
    
    // MARK: UI
    private lazy var ratingTableView = makeRatingTableView()
    private lazy var plugLabel = PlugLabel()
    
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
        ProgressHUD.show()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.countUsers != 0 {
            ProgressHUD.dismiss()
        }
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIBlockingProgressHUD.dismiss()
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
        tableView.accessibilityIdentifier = Consts.Statistic.ratingTableViewAccessibilityIdentifier
        return tableView
    }
    
    func makeRefreshControll() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(refresh(_:)),
            for: .valueChanged
        )
        return refreshControl
    }
    
    func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        navigationItem.title = ""
    }
    
    func navigationItemSetup() {
        let sortIcon = Asset.Assets.sortIcon.image.withTintColor(Asset.Colors.ypBlack.color, renderingMode: .alwaysTemplate)
        let filterButton = UIBarButtonItem(
            image: sortIcon,
            style: .done,
            target: self,
            action: #selector(sortedButtonTapped))
        filterButton.accessibilityIdentifier = Consts.Statistic.filterButtonAccessibilityIdentifier
        navigationItem.rightBarButtonItem = filterButton
        navigationController?.navigationBar.tintColor = Asset.Colors.ypBlack.color
    }
    
    func addViews() {
        [ratingTableView, plugLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            ratingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Consts.Statistic.topConstant),
            ratingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Consts.Statistic.sideConstant),
            ratingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Consts.Statistic.sideConstant),
            ratingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            plugLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
    func bind() {
        viewModel.showTableView = { [weak self] check in
            guard let self else { return }
            self.showTableView(show: check)
            self.reloadRatingTableView()
        }
        
        viewModel.showPlugView = { [weak self] (isHidden, text) in
            guard let self else { return }
            self.plugLabel.isHidden = !isHidden
            self.plugLabel.text = text
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    @objc
    func sortedButtonTapped() {
        viewModel.sortedButtonTapped()
    }
    
    @objc
    func refresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            self.viewModel.fetchUsers()
            sender.endRefreshing()
        }
    }
        
    func reloadRatingTableView() {
        ratingTableView.reloadData()
        ratingTableView.layoutIfNeeded()
        ratingTableView.setContentOffset(.zero, animated: true)
    }

    func showTableView(show: Bool) {
        UIView.animate(withDuration: 0.3) { [weak ratingTableView] in
            guard let ratingTableView else { return }
            ratingTableView.alpha = show ? 1 : 0
        }
        UIBlockingProgressHUD.dismiss()
    }
}

// MARK: UITableViewDelegate
extension RatingViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.didSelectUser(at: indexPath.row)
    }
}

// MARK: UITableViewDataSource
extension RatingViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
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
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        Consts.Statistic.heightUserTableViewCell
    }
}
