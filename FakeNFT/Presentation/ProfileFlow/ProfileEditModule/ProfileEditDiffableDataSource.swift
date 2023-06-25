//
//  ProfileEditDiffableDataSource.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 25.06.2023.
//

import UIKit

final class ProfileEditDiffableDataSource: UITableViewDiffableDataSource<String, String> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileEditCell.identifier,
                                                           for: indexPath)
                    as? ProfileEditCell
            else {
                return UITableViewCell()
            }
            
            cell.cellText = itemIdentifier
            return cell
        }
    }
    
    func reload(_ data: [ProfileTableDataModel], animated: Bool = true) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(data.map { $0.sectionCaption })
        data.forEach { model in
            snapshot.appendItems([model.cellText], toSection: model.sectionCaption)
        }
        apply(snapshot, animatingDifferences: animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}

struct ProfileTableDataModel {
    let sectionCaption: String
    let cellText: String
}
