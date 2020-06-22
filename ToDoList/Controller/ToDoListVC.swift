import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class ToDoListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    var todos: [Todos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background 2"))
        tableViewConfiguration()
        navControllerTitle()
        getUserData()
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func navControllerTitle() {
        guard let key = Auth.auth().currentUser?.uid else { return }
        self.ref.child("users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
        let value = snapshot.value as? NSDictionary
            let userName = value?["userName"] as? String
            self.navigationItem.title = userName
        }) { (error) in
            print(error.localizedDescription)
        }
     }
    
    private func getUserData() {
        guard let key = Auth.auth().currentUser?.uid else { return }
        let itemsRef = self.ref.child("users").child(key).child("toDos")
        itemsRef.observeSingleEvent(of: .value, with: { snapshot in
            var todoArr: [Todos] = []
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: Any]
                let postKey = snap.key
                let postTodo = dict["todo"] as! String
                let postDateAndTime = dict["dateAndTime"] as! String
                let post = Todos(todoKey: postKey, todo: postTodo, dateAndTime: postDateAndTime)
                todoArr.append(post)
            }
            self.todos = todoArr
            self.tableView.reloadData()
            print(self.todos)
        })
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        print("todo list done")
        let popUpVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.popUpVC) as! PopUpVC
        popUpVC.delegate = self
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        present(popUpVC, animated: true, completion: nil)
    }
    
    private func tableViewConfiguration() {
        tableView.register(UINib(nibName: Cells.todoCell, bundle: nil), forCellReuseIdentifier: Cells.todoCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.reloadData()
    }
}

extension ToDoListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.todoCell, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        cell.configurecell(todo: todos[indexPath.row])
        let viewSeparatorLine = UIView(frame:CGRect(x: 0, y: cell.contentView.frame.size.height - 1, width: cell.contentView.frame.size.width, height: 2))
        viewSeparatorLine.backgroundColor = UIColor(red: 142/255, green: 69/255, blue: 196/255, alpha: 1)
        cell.contentView.addSubview(viewSeparatorLine)
        cell.backgroundColor = .clear
        cell.isOpaque = false
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ToDoListVC: refreshDataDelegate {
    func refreshData() {
        getUserData()
    }
}

extension ToDoListVC: showAlertDelegate {
    
    func showAlert(customTableViewCell: UITableViewCell, didTapButton button: UIButton) {
        guard let indexPath = self.tableView.indexPath(for: customTableViewCell) else {return}
        let alert = UIAlertController(title: "Sorry", message: "Are You Sure Want to Delete this TODO?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            guard let userKey = Auth.auth().currentUser?.uid else { return}
            guard let todoKey = self.todos[indexPath.row].todoKey else {return}
            self.ref.child("users").child(userKey).child("toDos").child(todoKey).removeValue()
            self.getUserData()
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
}


