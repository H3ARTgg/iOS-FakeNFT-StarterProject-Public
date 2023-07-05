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
    var thereIsNfts: PassthroughSubject<Bool, Never> { get }

    var numberOfSections: Int { get }
        
    func viewDidLoad()
    func sortButtonTapped()
}

final class OwnedNftViewModel {
    var nfts = PassthroughSubject<[NftViewModel], Never>()
    var alert = PassthroughSubject<AlertModel, Never>()
    var thereIsNfts = PassthroughSubject<Bool, Never>()
    
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
        loadNextNfts()
    }
    
    func loadNextNfts() {
        ownedNfts.forEach { nftIndex in
            networkManager.getNft(nftId: nftIndex) { [weak self] nft in
                self?.loadedNfts.append(nft)
                self?.thereIsNfts.send(true)
            }
        }
    }
    
    func sortButtonTapped() {
        let alertText = Consts.LocalizedStrings.profileSortAlertTitle
        let alertByPriceActionText = Consts.LocalizedStrings.profileSortAlertByPriceText
        let alertByRatingActionText = Consts.LocalizedStrings.profileSortAlertByRatingText
        let alertByNameActionText = Consts.LocalizedStrings.profileSortAlertByNameText
        let alertCloseText = Consts.LocalizedStrings.profileSortAlertCloseText
        
        let alertSortByPriceAction = AlertAction(
            actionText: alertByPriceActionText,
            actionRole: .regular,
            action: { [unowned self] in
                self.sortBy(.price)
            }
        )
        
        let alertSortByRatingAction = AlertAction(
            actionText: alertByRatingActionText,
            actionRole: .regular,
            action: { [unowned self] in
                self.sortBy(.rating)
            }
        )
        
        let alertSortByNameAction = AlertAction(
            actionText: alertByNameActionText,
            actionRole: .regular,
            action: { [unowned self] in
                self.sortBy(.name)
            }
        )
        
        let alertSortCloseAction = AlertAction(
            actionText: alertCloseText,
            actionRole: .cancel,
            action: { }
        )
        
        let alertModel = AlertModel(
            alertText: alertText,
            alertActions: [
                alertSortByPriceAction,
                alertSortByRatingAction,
                alertSortByNameAction,
                alertSortCloseAction
            ])
        
        alert.send(alertModel)
    }
}

private extension OwnedNftViewModel {
    func sortBy(_ order: SortOrder) {
        switch order {
        case .price: loadedNfts = loadedNfts.sorted(by: { $0.price < $1.price })
        case .rating: loadedNfts = loadedNfts.sorted(by: { $0.rating > $1.rating })
        case .name: loadedNfts = loadedNfts.sorted(by: { $0.name < $1.name })
        }
    }
}

enum SortOrder {
    case price, rating, name
}
