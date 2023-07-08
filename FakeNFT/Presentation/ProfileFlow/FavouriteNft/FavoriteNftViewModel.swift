//
//  FavoriteNftViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 06.07.2023.
//

import Foundation
import Combine

protocol FavoriteNftViewModelProtocol {
    var nftsPublisher: AnyPublisher<[NftViewModel], NetworkError>? { get }
    var thereIsNfts: PassthroughSubject<Bool, Never> { get }
    
    func viewDidLoad()
}

final class FavoriteNftViewModel {
    var nftsPublisher: AnyPublisher<[NftViewModel], NetworkError>?
    var thereIsNfts = PassthroughSubject<Bool, Never>()

    private var ownedNfts: [String]
    private let networkManager: NftDataManagerProtocol = NftDataManager(networkService: DefaultNetworkClient())

    init(ownedNfts: [String]) {
        self.ownedNfts = ownedNfts
    }
}

extension FavoriteNftViewModel: FavoriteNftViewModelProtocol {
    func viewDidLoad() {
        nftsPublisher = networkManager.getNftsPublisher(nftIds: ownedNfts)
            .flatMap { nftsResponses in
                nftsResponses.publisher.setFailureType(to: NetworkError.self)
            }
            .flatMap { [unowned self] nftsResponse in
                self.networkManager.getUserNamePublisher(id: nftsResponse.author)
                    .map { author in
                        self.convert(nftsResponse, author: author)
                    }
            }
            .collect()
            .handleEvents(receiveCompletion: { [unowned self] _ in
                self.thereIsNfts.send(true)
            })
            .eraseToAnyPublisher()
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
