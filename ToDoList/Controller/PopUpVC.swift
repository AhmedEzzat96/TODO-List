import UIKit
import TextFieldEffects
import Firebase
import FirebaseAuth

protocol refreshDataDelegate {
    func refreshData()
}

class PopUpVC: UIViewController {
    
    let datePicker = UIDatePicker()
    @IBOutlet weak var dateAndTimeTextField: HoshiTextField!
    @IBOutlet weak var popUpImageView: UIImageView!
    @IBOutlet weak var contentTextField: HoshiTextField!
    var ref: DatabaseReference!
    var delegate: refreshDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        showDatePicker()
        textFieldDelegate()
        self.definesPresentationContext = true
        dateAndTimeTextField.addImageViewInsideMyTextField(image: "arrow")
        popUpImageView.layer.cornerRadius = 10
        popUpImageView.layer.masksToBounds = true
    }
    
    func updateUserData(todo: String, dateAndTime: String) {
        guard let key = Auth.auth().currentUser?.uid else { return }
        let values = ["todo": todo, "dateAndTime": dateAndTime]
        ref.child("users").child(key).child("toDos").childByAutoId().setValue(values)
     }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        // prevent from choosing outdated time and date
        datePicker.minimumDate = Date()
        
       //ToolBar
       let toolbar = UIToolbar()
       toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        dateAndTimeTextField.inputAccessoryView = toolbar
        dateAndTimeTextField.inputView = datePicker
    }

      @objc func doneDatePicker() {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy/MM/dd hh:mm a"
       dateAndTimeTextField.text = formatter.string(from: datePicker.date)
       self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if isValidData() {
            delegate?.refreshData()
            updateUserData(todo: contentTextField.text!, dateAndTime: dateAndTimeTextField.text!)
            self.dismiss(animated: true)
        }
    }
    
    private func isValidData() -> Bool {
        if let dateAndTime = dateAndTimeTextField.text, !dateAndTime.isEmpty, let content = contentTextField.text, !content.isEmpty {
            return true
        }
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        if dateAndTimeTextField.text?.isEmpty == true {
            alert.title = "Wrong date and time"
            alert.message = "Please enter a valid Date and time"
        }
        
        if contentTextField.text?.isEmpty == true {
            alert.title = "Wrong Content"
            alert.message = "Please enter content for your Todo"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return false
    }
}

extension PopUpVC: UITextFieldDelegate {
    
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
        dateAndTimeTextField.delegate = self
        contentTextField.delegate = self
    }
}
    
