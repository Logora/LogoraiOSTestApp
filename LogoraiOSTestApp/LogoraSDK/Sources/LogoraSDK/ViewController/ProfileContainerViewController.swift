import UIKit

class ProfileContainerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    func removeTopChildViewController() {
         if self.children.count > 0{
             let viewControllers:[UIViewController] = self.children
                viewControllers.last?.willMove(toParent: nil)
                viewControllers.last?.removeFromParent()
                viewControllers.last?.view.removeFromSuperview()
         }
     }
}
