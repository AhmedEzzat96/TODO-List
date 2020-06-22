import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpVC: UIViewController {
    
    @IBOutlet weak var userNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        userNameTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
        textFieldDelegate()
    }
    
    private func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password ) { (user, error) in
          if let e = error {
             let err = e as NSError
            let alert = UIAlertController(title: "Sign Up Failed",message: e.localizedDescription, preferredStyle: .alert)
             switch err.code {
             case AuthErrorCode.emailAlreadyInUse.rawValue:
                alert.message = err.localizedDescription
             default:
                alert.message = error?.localizedDescription
            }
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completionBlock(false)
            return
          } else {
                let userData = ["userName": self.userNameTextField.text,
                                  "email": self.emailTextField.text,
                                  "password": self.passwordTextField.text]
                self.ref.child("users").child(user?.user.uid ?? "").setValue(userData)
                print("add succefully")
                completionBlock(true)
          }
        }
    }
    
    private func isValidData() -> Bool {
        if let userName = userNameTextField.text, !userName.isEmpty, let email = emailTextField.text, !email.isEmpty, email.isValidEmail, let password = passwordTextField.text, !password.isEmpty, password.isValidPassword {
            return true
        }
        wrongUserAlert()
        return false
    }
    
    private func wrongUserAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        if emailTextField.text!.isValidEmail == false {
            alert.title = "Wrong Email Address"
            alert.message = "Your Email Address is wrong, please try again"
        }
        
        if passwordTextField.text!.isValidPassword == false {
            alert.title = "Wrong Password"
            alert.message = "password that must contain minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func goToSignInVc() {
        let signInVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signInVC) as! SignInVC
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func goToTODOListVc(){
        let todoListVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.toDoListVC) as! ToDoListVC
        self.navigationController?.pushViewController(todoListVC, animated: true)
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        if isValidData() {
            createUser(email: emailTextField.text!, password: passwordTextField.text!) { (bool) in
                if bool == true {
                    self.goToTODOListVc()
                }
            }
        }
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        goToSignInVc()
    }
}

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.alpha = 1
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            textField.alpha = 0.25
        } else {
            textField.alpha = 1
        }
        return true
    }

    func textFieldDelegate() {
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
}
