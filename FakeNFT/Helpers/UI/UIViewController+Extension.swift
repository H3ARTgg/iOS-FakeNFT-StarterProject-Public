import UIKit

// MARK: - Error UI
extension UIViewController {
    func setupErrorContent(with tuple: (UILabel, UIButton)) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            tuple.0.text = Consts.LocalizedStrings.errorConnectionMessage
            tuple.0.font = Consts.Fonts.regular17
            tuple.0.textColor = Asset.Colors.ypBlack.color
            
            tuple.1.setImage(nil, for: .normal)
            tuple.1.setTitle(Consts.LocalizedStrings.errorAlertAgain, for: .normal)
            tuple.1.setTitleColor(Asset.Colors.ypBlack.color, for: .normal)
            tuple.1.titleLabel?.font = Consts.Fonts.bold17
            tuple.1.layer.cornerRadius = 8
            tuple.1.layer.masksToBounds = true
            tuple.1.backgroundColor = Asset.Colors.ypLightGray.color
            tuple.1.translatesAutoresizingMaskIntoConstraints = false
            
            [tuple.0, tuple.1].forEach {
                self.view.addSubview($0)
            }
            
            tuple.0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            tuple.1.snp.makeConstraints { make in
                make.top.equalTo(tuple.0.snp.bottom).offset(10)
                make.leading.equalTo(self.view.snp.leading).offset(60)
                make.trailing.equalTo(self.view.snp.trailing).offset(-60)
                make.height.equalTo(35)
            }
        }
    }
}
