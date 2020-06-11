import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegate()
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func login(completionBlock: @escaping (_ success: Bool) -> Void) {
        guard
          let email = emailTextField.text,
          let password = passwordTextField.text,
          email.count > 0,
          password.count > 0
            else {return}

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
          if let error = error, user == nil {
            let alert = UIAlertController(title: "Sign In Failed",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            completionBlock(false)
            } else {
            completionBlock(true)
            }
        }
    }
    
    private func goToToDoList() {
        let toDoListVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.toDoListVC) as! ToDoListVC
        self.navigationController?.pushViewController(toDoListVC, animated: true)
    }

    @IBAction func logInBtnPressed(_ sender: UIButton) {
        login { (Bool) in
            if Bool == true {
                self.goToToDoList()
            } else {
              print("error")
            }
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        let signUpVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signUpVC) as! SignUpVC
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
}

extension SignInVC: UITextFieldDelegate {
    
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
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
}
