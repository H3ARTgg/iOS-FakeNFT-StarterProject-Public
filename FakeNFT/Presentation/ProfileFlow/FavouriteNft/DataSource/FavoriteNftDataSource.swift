//
//  FavoriteNftDataSource.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 06.07.2023.
//

import UIKit

final class FavoriteNftDataSource: UICollectionViewDiffableDataSource<Int, NftViewModel> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, NftViewModel>
    private var snapshot = Snapshot()
    
    init(_ collectionView: UICollectionView) {
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteNftCollectionViewCell.identifier, for: indexPath) as? FavoriteNftCollectionViewCell else {
                fatalError("cell not found")
            }
            
            cell.cellModel = itemIdentifier
           
            return cell
        }
    }
    
    func reload(_ data: [NftViewModel], animated: Bool = true) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)
        apply(snapshot, animatingDifferences: animated)
    }
}
