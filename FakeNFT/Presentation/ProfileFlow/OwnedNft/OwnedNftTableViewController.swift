//
//  OwnedNftViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import UIKit
import Combine

final class OwnedNftTableViewController: UITableViewController {
    
    private lazy var nftsDataSource = OwnedNftDataSource(tableView: tableView)
    private let viewModel: OwnedNftViewModelProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: OwnedNftViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nftsDataSource
        tableView.delegate = self
        tableView.register(OwnedNftTableViewCell.self, forCellReuseIdentifier: OwnedNftTableViewCell.identifier)
        tableView.separatorStyle = .none
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        let rightBarButtonItem = UIBarButtonItem(image: Consts.Images.sorMenu,
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(showSortMenu))
        
        rightBarButtonItem.tintColor = Asset.Colors.ypBlack.color
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        title = "Мои Nft" // TODO: Localization
    }
    
    @objc
    func showSortMenu() {
        
    }
    
    func setupBindings() {
        viewModel.nfts.sink { [weak self] nfts in
            self?.nftsDataSource.reload(nfts)
        }
        .store(in: &cancellables)
    }
}

// MARK: - TableView Delegate

extension OwnedNftTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadNextNfts(indexPath.row + 1)
    }
}

extension OwnedNftTableViewController {
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
