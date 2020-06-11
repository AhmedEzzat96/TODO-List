import Foundation

extension String {
    
    var isValidEmail: Bool {
        get {
            let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
            let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
            return emailTest.evaluate(with: self)
        }
    }
    
    var isValidPassword: Bool {
        get {
            let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
            return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
        }
    }
}
