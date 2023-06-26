import Foundation

protocol WebViewViewModelProtocol {
    var loadURL: ((URL) -> Void)? { get set }
    func loadSite()
}

final class WebViewViewModel: WebViewViewModelProtocol {
    public var loadURL: ((URL) -> Void)?
    
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func loadSite() {
        guard let url else { return }
        loadURL?(url)
    }
}
