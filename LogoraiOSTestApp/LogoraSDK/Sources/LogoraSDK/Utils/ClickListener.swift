import UIKit

class ClickListener: UITapGestureRecognizer {
    var onClick : ((_: Any?) -> Void)?
    var clickedObject: Any?
    
    init(target: Any?, action: Selector?, clickedObject: Any? = nil, onClick: ((_: Any?) -> Void)? = nil) {
        self.clickedObject = clickedObject
        self.onClick = onClick
        super.init(target: target, action: action)
    }
}
