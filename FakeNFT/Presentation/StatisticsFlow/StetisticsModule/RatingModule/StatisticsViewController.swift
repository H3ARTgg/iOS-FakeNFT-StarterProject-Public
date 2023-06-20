import UIKit

/// Контролле отвечает за отображение списка пользователей
final class RatingViewController: UIViewController {
    
    // MARK: UI
    private lazy var ratingTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItemSetup()
        addViews()
        activateConstraints()
    }
}

extension RatingViewController {
    func  navigationItemSetup() {
        let filterButton = UIBarButtonItem(
            image: Consts.Images.sortIcon,
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
