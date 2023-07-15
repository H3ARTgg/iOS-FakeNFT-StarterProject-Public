//
//  ModulesFactory.swift
//  Tracker
//
//  Created by Aleksandr Velikanov on 01.04.2023.
//

import Foundation

protocol ModulesFactoryProtocol {
    func makeCartView() -> (view: Presentable, coordination: CartCoordination)
    func makeDeleteNftView(nft: Nft?, cartViewModel: CartViewModel) -> (view: Presentable, coordination: CartCoordination)
    func makePaymentView(cartViewModel: CartViewModel) -> (view: Presentable, coordination: PaymentCoordination)
    func makePaymentResultView(_ state: ViewState, _ cartViewModel: CartViewModel) -> (view: Presentable, coordination: CartCoordination)
    func makeAboutWebView(url: URL) -> Presentable
}

struct ModulesFactory: ModulesFactoryProtocol {
    let cartNetworkService: CartNetworkServiceProtocol = CartNetworkService(networkClient: DefaultNetworkClient())
    let paymentNetworkService: PaymentNetworkServiceProtocol = PaymentNetworkService(networkClient: DefaultNetworkClient())
}

// MARK: - Cart Flow

extension ModulesFactory {
    func makeCartView() -> (view: Presentable, coordination: CartCoordination) {
        let cartViewModel = CartViewModel(cartNetworkService: cartNetworkService)
        let cartViewController = CartViewController(cartViewModel: cartViewModel)
        return (cartViewController, cartViewModel)
    }
    
    func makeDeleteNftView(nft: Nft?, cartViewModel: CartViewModel) -> (view: Presentable, coordination: CartCoordination) {
        let deleteNftViewController = DeleteNftViewController(cartViewModel: cartViewModel)
        deleteNftViewController.nft = nft
        return (deleteNftViewController, cartViewModel)
    }
    
    func makePaymentView(cartViewModel: CartViewModel) -> (view: Presentable, coordination: PaymentCoordination) {
        let paymentViewModel = PaymentViewModel(paymentNetworkService: paymentNetworkService)
        let paymentViewController = PaymentViewController(cartViewModel: cartViewModel, paymentViewModel: paymentViewModel)
        return (paymentViewController, paymentViewModel)
    }
    
    func makePaymentResultView(_ state: ViewState, _ cartViewModel: CartViewModel) -> (view: Presentable, coordination: CartCoordination) {
        let paymentResultViewController = PaymentResultViewController(cartViewModel: cartViewModel)
        paymentResultViewController.state = state
        return (paymentResultViewController, cartViewModel)
    }
    
    func makeAboutWebView(url: URL) -> Presentable {
        let webViewViewModel = WebViewViewModel(url: url)
        let webViewController = WebViewViewController(viewModel: webViewViewModel)
        return webViewController
    }
}
