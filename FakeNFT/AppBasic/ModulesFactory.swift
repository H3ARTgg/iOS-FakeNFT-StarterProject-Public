//
//  ModulesFactory.swift
//  Tracker
//
//  Created by Aleksandr Velikanov on 01.04.2023.
//

import Foundation

protocol ModulesFactoryProtocol {
    func makeAboutWebView(urlString: String) -> Presentable
    func makeCatalogueView() -> (view: Presentable, coordination: CatalogueCoordination)
    func makeCollectionDetailsViewWith(collectionId: String) -> (view: Presentable, coordination: CollectionDetailsCoordination)
}

struct ModulesFactory: ModulesFactoryProtocol {
    func makeAboutWebView(urlString: String) -> Presentable {
        let url = URL(string: urlString)
        let webViewViewModel = WebViewViewModel(url: url)
        let webViewController = WebViewViewController(viewModel: webViewViewModel)
        return webViewController
    }
}

// MARK: - CatalogueFlow
extension ModulesFactory {
    func makeCatalogueView() -> (view: Presentable, coordination: CatalogueCoordination) {
        let catalogueVM = CatalogueViewModel(networkClient: DefaultNetworkClient())
        let catalogueVC = CatalogueViewController(viewModel: catalogueVM)
        return (catalogueVC, catalogueVM)
    }
    
    func makeCollectionDetailsViewWith(collectionId: String) -> (view: Presentable, coordination: CollectionDetailsCoordination) {
        let colDetVM = CollectionDetailsViewModel(collectionId: collectionId, networkClient: DefaultNetworkClient())
        let colDetVC = CollectionDetailsViewController(viewModel: colDetVM)
        return (colDetVC, colDetVM)
    }
}
