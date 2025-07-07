import UIKit

extension UIView {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        animation.duration = 0.4
        layer.add(animation, forKey: "shake")
    }
    
}
