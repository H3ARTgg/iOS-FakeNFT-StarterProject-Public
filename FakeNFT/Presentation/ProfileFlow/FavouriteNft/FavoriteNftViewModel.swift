//
//  FavoriteNftViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 06.07.2023.
//

import Foundation
import Combine

protocol FavoriteNftCoordination {
    var finish: (([String]) -> Void)? { get set }
}

protocol CollectionViewModelProtocol: AnyObject {
    func likeButtonTap(with id: String)
}

protocol FavoriteNftViewModelProtocol {
    var nftsPublisher: AnyPublisher<[NftViewModel], NetworkError>? { get }
    var getNfts: PassthroughSubject<Void, NetworkError> { get }
    var thereIsNfts: PassthroughSubject<Bool, Never> { get }
    var showLoading: PassthroughSubject<Bool, Never> { get }
    
    func requestNfts()
    func backButtonTapped()
}

final class FavoriteNftViewModel: FavoriteNftCoordination {
    var finish: (([String]) -> Void)?
    
    private(set) var nftsPublisher: AnyPublisher<[NftViewModel], NetworkError>?
    private(set) var getNfts = PassthroughSubject<Void, NetworkError>()
    private(set) var thereIsNfts = PassthroughSubject<Bool, Never>()
    private(set) var showLoading = PassthroughSubject<Bool, Never>()
    
    private let networkManager: NftDataManagerProtocol
    private var favoriteNfts: [String]
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkManager: NftDataManagerProtocol, favoriteNfts: [String]) {
        self.favoriteNfts = favoriteNfts
        self.networkManager = networkManager
        
        nftsPublisher = getNfts.flatMap { [unowned self] _ in
            self.showLoading.send(true)
            return networkManager.getNftsPublisher(nftIds: self.favoriteNfts)
                .flatMap { nftsResponses in
                    nftsResponses.publisher.setFailureType(to: NetworkError.self)
                }
                .flatMap { nftsResponse in
                    networkManager.getUserNamePublisher(id: nftsResponse.author)
                        .compactMap { [weak self]  author in
                            self?.convert(nftsResponse, author: author)
                        }
                }
                .collect()
                .handleEvents(receiveOutput: { [weak self] nfts in
                    if nfts.isEmpty {
                        self?.thereIsNfts.send(false)
                    } else {
                        self?.thereIsNfts.send(true)
                    }
                })
                .handleEvents(receiveCompletion: { [weak self] _ in
                    self?.showLoading.send(false)
                })
        }
        .eraseToAnyPublisher()
    }
}

extension FavoriteNftViewModel: FavoriteNftViewModelProtocol {
    func backButtonTapped() {
        finish?(favoriteNfts)
    }
    
    func requestNfts() {
        getNfts.send()
    }
}

extension FavoriteNftViewModel {
    func convert(_ response: NftResponseModel, author: String) -> NftViewModel {
        NftViewModel(id: response.id,
                     image: response.images[0],
                     name: response.name,
                     rating: response.rating,
                     author: author,
                     price: response.price,
                     isLiked: true)
    }
}

extension FavoriteNftViewModel: CollectionViewModelProtocol {
    func likeButtonTap(with id: String) {
        networkManager.removeFavoriteNft(id)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] profileResponse in
                print(profileResponse.likes)
                self?.favoriteNfts = profileResponse.likes
                self?.getNfts.send()
            }
            .store(in: &cancellables)
    }
}
