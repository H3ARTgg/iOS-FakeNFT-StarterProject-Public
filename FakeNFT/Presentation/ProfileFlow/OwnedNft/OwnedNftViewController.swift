//
//  OwnedNftViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import UIKit
import Combine

final class OwnedNftViewController: UIViewController {
    
    private lazy var nftsDataSource = OwnedNftDataSource(tableView: nftsTableView)
    private let viewModel: OwnedNftViewModelProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var nftsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.register(OwnedNftTableViewCell.self, forCellReuseIdentifier: OwnedNftTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var noNftsLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold17
        label.text = Consts.LocalizedStrings.profileYouHaveNotAnyNfts
        label.textColor = Asset.Colors.ypBlack.color
        return label
    }()
    
    init(viewModel: OwnedNftViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        addSubviews()
        configure()
        applyLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nftsTableView.dataSource = nftsDataSource
        setupBindings()
        viewModel.viewDidLoad()
    }

    @objc
    func showSortMenu() {
        viewModel.sortButtonTapped()
    }
    
    func setupBindings() {
        viewModel.nfts.sink { [weak self] nfts in
            self?.nftsDataSource.reload(nfts)
        }
        .store(in: &cancellables)
        
        viewModel.alert.sink { [weak self] alertModel in
            self?.presentActionSheet(alertModel: alertModel)
        }
        .store(in: &cancellables)
        
        viewModel.thereIsNfts
            .removeDuplicates()
            .sink { [weak self] state in
                guard let self = self else { return }
                let rightBarButtonItem = UIBarButtonItem(image: Consts.Images.sortMenu,
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(self.showSortMenu))
                rightBarButtonItem.tintColor = Asset.Colors.ypBlack.color

                DispatchQueue.main.async {
                    if state {
                        self.navigationItem.rightBarButtonItem = rightBarButtonItem
                        self.title = "Мои Nft" // TODO: Localization
                    }

                    self.nftsTableView.isHidden = false
                    self.noNftsLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - TableView Delegate

extension OwnedNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension OwnedNftViewController {
    func presentActionSheet(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.alertText, message: nil, preferredStyle: .actionSheet)
        alertModel.alertActions.forEach { alertAction in
            let actionStyle: UIAlertAction.Style
            switch alertAction.actionRole {
            case .destructive: actionStyle = .destructive
            case .regular: actionStyle = .default
            case .cancel: actionStyle = .cancel
            }
            
            let action = UIAlertAction(title: alertAction.actionText, style: actionStyle, handler: { _ in alertAction.action?() })
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
}

// MARK: - Subviews configure + layout
private extension OwnedNftViewController {
    func addSubviews() {
        view.addSubview(nftsTableView)
        view.addSubview(noNftsLabel)
    }
    
    func configure() {
        nftsTableView.translatesAutoresizingMaskIntoConstraints = false
        noNftsLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            nftsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nftsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            noNftsLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noNftsLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
