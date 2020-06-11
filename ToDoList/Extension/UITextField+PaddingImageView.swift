import Foundation
import UIKit

extension UITextField {
    func addImageViewInsideMyTextField(image: String) {
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        imageView.contentMode = .scaleAspectFit
        imageView.setImageColor(color: UIColor(red: 89/255, green: 35/255, blue: 119/255, alpha: 1))
        someView.addSubview(imageView)
        self.rightView = someView
        self.rightViewMode = .always
    }
}
