import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    weak var delegate: showAlertDelegate?
    var callback : ((UITableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurecell(todo: Todos) {
        dateAndTimeLabel.text = todo.dateAndTime
        contentLabel.text = todo.todo
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        callback?(self)
        self.delegate?.showAlert(customTableViewCell: self, didTapButton: sender)
    }
    
}

protocol showAlertDelegate: class {
    func showAlert(customTableViewCell: UITableViewCell, didTapButton button: UIButton)
}
