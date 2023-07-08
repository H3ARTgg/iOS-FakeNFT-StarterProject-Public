//
//  ProfileEditTableView.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 25.06.2023.
//

import UIKit
import Combine

final class ProfileEditTableView: UITableViewController {
    private let viewModel: ProfileEditViewModelProtocol
    
    private var cancellables: Set<AnyCancellable> = []

    private lazy var tableHeaderView = ProfileEditTableHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 174))
    
    init(viewModel: ProfileEditViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableHeaderView.userPicUrl = viewModel.urlForProfileImage
    }
}

// MARK: - TableView Data Source

extension ProfileEditTableView {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileEditCell.identifier,
            for: indexPath
        ) as? ProfileEditCell else {
            return UITableViewCell()
        }
        
        cell.cellText = viewModel.cellDataForRow(indexPath.section).cellText
        
        cell.cellOutput.sink { [weak self] text in
            self?.viewModel.storeText(text, at: indexPath.section)
        }
        .store(in: &cancellables)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSections
    }
}

// MARK: - TableView Delegate

extension ProfileEditTableView {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.cellDataForRow(indexPath.section).сellAppearance.cellHeight
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ProfileEditSectionHeaderView.identifier
        ) as? ProfileEditSectionHeaderView else {
            return UIView()
        }
        
        sectionHeaderView.headerText = viewModel.cellDataForRow(section)
            .сellAppearance
            .cellIdentifier
            .localizedString
        return sectionHeaderView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
}

// MARK: - Private Methods

private extension ProfileEditTableView {
    func setupTableView() {
        tableView.register(ProfileEditCell.self,
                           forCellReuseIdentifier: ProfileEditCell.identifier)
        
        tableView.register(ProfileEditSectionHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: ProfileEditSectionHeaderView.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.closeButtonClosure = { [weak self] in
            self?.viewModel.closeButtonTapped()
            self?.dismiss(animated: true)
        }
    }
}
