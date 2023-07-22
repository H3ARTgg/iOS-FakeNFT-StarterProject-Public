//
//  OwnedNftDataSource.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import UIKit

final class OwnedNftDataSource: UITableViewDiffableDataSource<Int, NftViewModel> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: OwnedNftTableViewCell.identifier,
                for: indexPath
            ) as? OwnedNftTableViewCell else {
                return UITableViewCell()
            }
            
            cell.cellModel = itemIdentifier
            return cell
        }
    }
    
    func reload(_ data: [NftViewModel], animated: Bool = true) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        apply(snapshot, animatingDifferences: animated)
    }
}
