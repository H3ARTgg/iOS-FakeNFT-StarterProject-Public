import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    // MARK: private properties
    private var viewModel: WebViewViewModelProtocol
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: UI
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .clear
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = Asset.Colors.ypBlueUniversal.color
        progressView.trackTintColor = Asset.Colors.ypWhite.color
        return progressView
    }()
    
    // MARK: Initialization
    init(viewModel: WebViewViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        addViews()
        activateConstraints()
        setObserver()
        bind()
        viewModel.loadSite()
    }
}

extension WebViewViewController {
    private func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
    }
    
    private func addViews() {
        [ webView, progressView].forEach {
            view.addSubview($0)
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leftAnchor.constraint(equalTo: view.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
        
    private func bind() {
        viewModel.loadURL = { [weak webView] url in
            guard let webView else { return }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setObserver() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.didUpdateProgressValue(self.webView.estimatedProgress)
             })
    }
    
    private func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        progressView.progress = newProgressValue
        progressView.isHidden = shouldHideProgress(for: newProgressValue)
    }
    
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
