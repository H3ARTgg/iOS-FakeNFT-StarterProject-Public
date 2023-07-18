//
//  ProfileDiffableDataSource.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 23.06.2023.
//

import UIKit

final class ProfileDataSource: UITableViewDiffableDataSource<Int, ProfileCellModel> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ProfileTableViewCell.identifier,
                for: indexPath
            ) as? ProfileTableViewCell else {
                return UITableViewCell()
            }
            
            cell.cellModel = itemIdentifier
            return cell
        }
    }
    
    func reload(_ data: [ProfileCellModel], animated: Bool = true) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        apply(snapshot, animatingDifferences: animated)
    }
}
