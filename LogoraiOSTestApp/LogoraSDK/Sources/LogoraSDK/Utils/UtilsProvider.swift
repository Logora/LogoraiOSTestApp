import UIKit

class UtilsProvider {
    static let sharedInstance = UtilsProvider()
    static let settings = SettingsProvider.sharedInstance
    private var loaderViewController: SpinnerViewController! = SpinnerViewController()
    
    private init() {
    }
    
    static func getLocalizedString(textKey: String) -> String {
        let textValue = settings.get(key: "layout." + textKey)
        if(!textValue.isEmpty) {
            return textValue
        } else {
            return NSLocalizedString(textKey, bundle: Bundle(for: type(of: settings)), comment: "")
        }
    }
    
    func getFormattedDateString(format: String, dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func showLoader(currentVC: UIViewController) {
        currentVC.addChild(loaderViewController)
        loaderViewController.view.frame = currentVC.view.frame
        currentVC.view.addSubview(loaderViewController.view)
        loaderViewController.didMove(toParent: currentVC)
    }
    
    func hideLoader() {
        loaderViewController.willMove(toParent: nil)
        loaderViewController.view.removeFromSuperview()
        loaderViewController.removeFromParent()
    }
}
