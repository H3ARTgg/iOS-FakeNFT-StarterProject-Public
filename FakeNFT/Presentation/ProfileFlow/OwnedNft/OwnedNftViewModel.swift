//
//  OwnedNftViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import Foundation
import Combine

protocol OwnedNftCoordination {
    var headForActionSheet: ((AlertModel) -> Void)? { get set }
}

protocol OwnedNftViewModelProtocol {
    var nfts: CurrentValueSubject<[NftViewModel], Never> { get }
    var thereIsNfts: PassthroughSubject<Bool, Never> { get }
    var showLoading: PassthroughSubject<Bool, Never> { get }
    
    var numberOfSections: Int { get }
    
    func sortButtonTapped()
    func viewDidLoad()
}

final class OwnedNftViewModel: OwnedNftCoordination {
    var headForActionSheet: ((AlertModel) -> Void)?
    
    private(set) var nfts = CurrentValueSubject<[NftViewModel], Never>([])
    private(set) var thereIsNfts = PassthroughSubject<Bool, Never>()
    private(set) var showLoading = PassthroughSubject<Bool, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private var likes: [String] = []
    private var nftsPublisher: AnyPublisher<[NftViewModel], NetworkError>!
    
    init(networkManager: NftDataManagerProtocol, ownedNfts: [String]) {
        nftsPublisher = networkManager.getNftsPublisher(nftIds: ownedNfts)
            .flatMap { nftsResponses in
                nftsResponses.publisher.setFailureType(to: NetworkError.self)
            }
            .flatMap { [weak self] nftsResponse in
                networkManager.getUserNamePublisher(id: nftsResponse.author)
                    .compactMap { author in
                        self?.convert(nftsResponse, author: author)
                    }
            }
            .flatMap { [weak self] viewModel in
                networkManager.getSetProfilePublisher(nil)
                    .compactMap { response in
                        self?.convert(viewModel, likes: response.likes)
                    }
            }
            .collect()
            .eraseToAnyPublisher()
    }
}

extension OwnedNftViewModel: OwnedNftViewModelProtocol {
    func viewDidLoad() {
        nftsPublisher.handleEvents(receiveRequest: { [weak self] _ in
            self?.showLoading.send(true)
        })
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] error in
                print(error)
                self?.showLoading.send(false)
            },
            receiveValue: { [weak self] nfts in
                self?.nfts.send(nfts)
                if nfts.isEmpty {
                    self?.thereIsNfts.send(false)
                } else {
                    self?.thereIsNfts.send(true)
                }
            }
        )
        .store(in: &cancellables)
    }
    
    var numberOfSections: Int {
        1
    }
    
    func sortButtonTapped() {
        let alertText = L10n.Profile.sort
        let alertByPriceActionText = L10n.Profile.byPrice
        let alertByRatingActionText = L10n.Profile.byRating
        let alertByNameActionText = L10n.Profile.byTitle
        let alertCloseText = L10n.Profile.close
        
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
        
        headForActionSheet?(alertModel)
    }
}

private extension OwnedNftViewModel {
    enum SortOrder {
        case price, rating, name
    }
    
    func sortBy(_ order: SortOrder) {
        switch order {
        case .price: nfts.send(nfts.value.sorted { $0.price < $1.price })
        case .rating: nfts.send(nfts.value.sorted { $0.rating > $1.rating })
        case .name: nfts.send(nfts.value.sorted { $0.name < $1.name })
        }
    }
    
    func convert(_ response: NftResponseModel, author: String) -> NftViewModel {
        NftViewModel(id: response.id,
                     image: response.images[0],
                     name: response.name,
                     rating: response.rating,
                     author: author,
                     price: response.price,
                     isLiked: false)
    }
    
    func convert(_ viewModel: NftViewModel, likes: [String]) -> NftViewModel {
        NftViewModel(id: viewModel.id,
                     image: viewModel.image,
                     name: viewModel.name,
                     rating: viewModel.rating,
                     author: viewModel.author,
                     price: viewModel.price,
                     isLiked: likes.contains(viewModel.id))
    }
}
