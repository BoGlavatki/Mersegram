//
//  CommentViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 01.04.22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ommentTextField: UIView!
   

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    @IBOutlet weak var textField: UITextField!
    //MARK: VAR LET
    var post: PostModel?
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
            tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.keyboardDismissMode = .interactive

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addTargetToTextField()
        empty()
        loadComments()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Keyboard stuff
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.1) {
            self.bottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHidden(_ notifcation: NSNotification){
        
        UIView.animate(withDuration: 0.2) {
            self.bottom.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    func addTargetToTextField(){
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
       
    }
    @objc func textFieldDidChange(){
        let isText = textField.text?.count ?? 0 > 0
        
        if isText{
            sendButton.setTitleColor(.black, for: UIControl.State.normal)
            sendButton.isEnabled = true
        }else{
            sendButton.setTitleColor(.lightGray, for: UIControl.State.normal)
            sendButton.isEnabled = false
        }    }
    //MARK: _ Send Comment
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        createComment()
        
    }
    
    //MARK: Create UserComment in FirebaseDatabase
    func createComment(){
        
        let refDatabase = Database.database(url:"https://mersegram-default-rtdb.europe-west1.firebasedatabase.app").reference()
        let refComments = refDatabase.child("comments")//BENENEN Die abteilung
        let commetnId = refComments.childByAutoId().key ?? "" //ID zuweisen
        
        let newCommentRef = refComments.child(commetnId) // zugewissene ID des Kommentars als Bereich erstellen
        
      guard let uid = Auth.auth().currentUser?.uid else { return}
        
        let dic = ["uid" : uid, "commentText" : textField.text] as [String : Any]
        newCommentRef.setValue(dic) {(error, ref) in //Text von textFeld einlesen und in Dictionary speichern
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
            }
            guard let postId = self.post?.id else { return }
            let postCommentRef = Database.database(url:"https://mersegram-default-rtdb.europe-west1.firebasedatabase.app").reference().child("post-commets").child(postId).child(commetnId)
            postCommentRef.setValue(true, withCompletionBlock:  { (error, ref )in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                self.view.endEditing(true)
                self.empty()
            })
        }
        
    }
    func empty(){
        textField.text=""
        sendButton.isEnabled = false
        sendButton.setTitleColor(.lightGray, for: UIControl.State.normal)
    }
    //MARK: LOAD COMMENTS
    
    func loadComments(){
        guard let postID = post?.id else {return}
            let postCommentRef = Database.database(url:"https://mersegram-default-rtdb.europe-west1.firebasedatabase.app").reference().child("post-commets").child(postID)
            
        postCommentRef.observe(.childAdded) { (snapshot ) in
            print("comment id ", snapshot.key)
        }
    }
    
    
    
    
    
    
    
    
}




//MARK: TableViewDataSource
extension CommentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    //WIE VIELE ZEILE IN DIESE TABELLE
   
    //WIE AUSSEHEN SOLL
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
       // let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        return cell
    }
}
