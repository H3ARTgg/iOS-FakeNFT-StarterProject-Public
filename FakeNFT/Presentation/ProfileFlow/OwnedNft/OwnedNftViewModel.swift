//
//  OwnedNftViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import Foundation
import Combine

protocol OwnedNftViewModelProtocol {
    var nfts: PassthroughSubject<[NftViewModel], Never> { get }
    var alert: PassthroughSubject<AlertModel, Never> { get }

    var numberOfSections: Int { get }
        
    func viewDidLoad()
    func loadNextNfts(_ index: Int)
}

final class OwnedNftViewModel {
   
    var nfts = PassthroughSubject<[NftViewModel], Never>()
    var alert = PassthroughSubject<AlertModel, Never>()
    
    var loadedNfts: [NftResponseModel] = [] {
        didSet {
            let data = loadedNfts.map { model in
                NftViewModel(image: model.images[0],
                             name: model.name,
                             rating: model.rating,
                             author: model.author,
                             price: model.price)
            }
            
            nfts.send(data)
        }
    }
    
    private var ownedNfts: [String]
    private let networkManager: NftDataManagerProtocol = NftDataManager(networkService: DefaultNetworkClient())
    private var lastLoadedNft: Int = -1
    
    init(ownedNfts: [String]) {
        self.ownedNfts = ownedNfts
    }
}

extension OwnedNftViewModel: OwnedNftViewModelProtocol {
    var numberOfSections: Int {
        1
    }
    
    func viewDidLoad() {
        loadNextNfts(0)
    }
    
    func loadNextNfts(_ index: Int) {
        if index > lastLoadedNft, ownedNfts.indices ~= index {
            lastLoadedNft += 4
            ownedNfts[index...min(ownedNfts.count - 1, lastLoadedNft)].forEach { nftIndex in
                networkManager.getNft(nftId: nftIndex) { [weak self] nft in
                    self?.loadedNfts.append(nft)
                }
            }
        }
    }
    
    func sortBy(_ order: SortOrder) {
        switch order {
        case .price: break
        case .rating: break
        case .name: break 
        }
    }
    
    func alertButtonTapped() {
        let alertText = NSLocalizedString("deleteTrackerAlertText", comment: "Text for tracker delete alert")
        let alertDeleteActionText = NSLocalizedString("deleteActionText", comment: "Text for alert delete button")
        let alertCancelText = NSLocalizedString("cancelActionText", comment: "Text for alert cancel button")
        let alertDeleteAction = AlertAction(actionText: alertDeleteActionText, actionRole: .destructive, action: { [unowned self] in
            let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
            do {
                try dataProvider.deleteTracker(tracker)
            } catch {
                handleError(message: error.localizedDescription)
            }
            
            dateChangedTo(date)
        })
        
        let alertCancelAction = AlertAction(actionText: alertCancelText, actionRole: .cancel, action: nil)
        let alertModel = AlertModel(alertText: alertText, alertActions: [alertDeleteAction, alertCancelAction])
    }
}

enum SortOrder {
    case price, rating, name
}
