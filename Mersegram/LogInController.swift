//
//  LogInController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 19.03.22.
//

import UIKit
import FirebaseAuth

class LogInController: UIViewController {
    
    //Email, password, login Outlet
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addTargetToTextField()
        
        //LOGIN WENN TEXT VORHANDEN IST
        
    }
    
    //MARK: METHODE FÜR TASTATUR VERSCHWINDUNG
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {(timer) in
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                })
            }
        }
    }
    
//MARK: - METHODE
   
    func setupViews(){
        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        emailTextField.borderStyle = .roundedRect
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        
        //LOGINBUTTON WENN FELDER NICHT AUSGEFÜLLT SIND OHNE FUNKTIONHALTEN
        logInButton.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        logInButton.layer.cornerRadius = 5
        logInButton.isEnabled = false
    }
    
    func addTargetToTextField(){
        //AB SWIFT 4.2 editingChanged -> UIControl.Event.editingChanged
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    @objc func textFieldDidChange(){
        let isText = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isText{
            logInButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            logInButton.layer.cornerRadius = 5
            logInButton.isEnabled = true
        }
        else{
            
            logInButton.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
            logInButton.layer.cornerRadius = 5
            logInButton.isEnabled = false
        }
    }
    
    //MARK - Actions
    
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        AuthenticationService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }){
            (error) in
            print(error!)
        }
        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
