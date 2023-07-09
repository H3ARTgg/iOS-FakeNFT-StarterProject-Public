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
        tableView.isHidden = false
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
    }
    
    func setupBindings() {
        viewModel.nfts.sink(
            receiveCompletion: { error in
                print(error)
            },
            receiveValue: { [weak self] nfts in
                self?.nftsDataSource.reload(nfts)
            })
        .store(in: &cancellables)

        viewModel.thereIsNfts
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
                        self.title = Consts.LocalizedStrings.ownedNfts
                    }

                    self.nftsTableView.isHidden = false
                    self.noNftsLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
    
    @objc
    func showSortMenu() {
        viewModel.sortButtonTapped()
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
