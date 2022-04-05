//
//  CommentViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 01.04.22.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ommentTextField: UIView!
   
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var textField: UITextField!
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
            tableView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        let isText = textField.text?.count ?? 0 > 0
        
        if isText{
            sendButton.setTitleColor(.black, for: UIControl.State.normal)
            sendButton.isEnabled = true
        }else{
            sendButton.setTitleColor(.lightGray, for: UIControl.State.normal)
            sendButton.isEnabled = false
        }
    }
    @objc func textFieldDidChange(){
        
    }
    //MARK: _ Send Comment
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
    print("KOMMENTAR SENDEN")
        view.endEditing(true)
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
