//
//  RegistrationViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 19.03.22.
//

import UIKit

 import FirebaseAuthUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Outlet
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var AccountErstellen: UIButton!
    
    
    @IBOutlet weak var haveAnAccountButton: UIButton!
    
    //MARK  - var / let
    var selectedImage: UIImage?
    
    //MARK VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        addTargetToTextField()
        
        addTapGestureToImageview()
        
        // Do any additional setup after loading the view.
    }
    

   //MARK METHODEN
    func setupView(){
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2
        
        userNameTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.attributedPlaceholder = NSAttributedString(string: userNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        
        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        emailTextField.borderStyle = .roundedRect
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
     
        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        
        AccountErstellen.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        AccountErstellen.layer.cornerRadius = 5
        AccountErstellen.isEnabled = false
        
        let attributetText = NSMutableAttributedString(string: "Du hast eine Account ? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.white])
        
        attributetText.append(NSAttributedString(string: " " + "Login", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        haveAnAccountButton.setAttributedTitle(attributetText, for: .normal)
    
    
    }
    
    func addTargetToTextField(){
        
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    @objc func textFieldDidChange(){
        let isText = userNameTextField.text?.count ?? 0 > 0 && emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isText{
            
            AccountErstellen.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            AccountErstellen.layer.cornerRadius = 5
            AccountErstellen.isEnabled = true
            
        }
        else{
            AccountErstellen.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
            AccountErstellen.layer.cornerRadius = 5
            AccountErstellen.isEnabled = false
        }
    }
    
    
    //MARK - CHOICE FOTO
    
    
    func addTapGestureToImageview(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilPhoto))
  
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
    
    }
    
    @objc func handleSelectProfilPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage]as? UIImage{//QUASI FOTO ZU PROFILIMAGE HINZUFÜGEN
            profileImageView.image = editImage //Erscheint in profil Ding FOTO
            selectedImage = editImage
         }
        else if let originalImage = info[.originalImage] as? UIImage{
            profileImageView.image = originalImage // Bleibt altes Bild
            selectedImage = originalImage//FALS HAT USER NICHT VERÄNDERT
        }
        dismiss(animated: true, completion: nil)//CHOICE FENSTER VERSCHWINDET NACH DEM CHOICE TAPPEN
    }
    
    
    
    
    
    //MARK ACTION
    //ERSTELLEN DES USERS NACH DEM BUTTEN ERSTELLEN ANGETIPT WIRD
    @IBAction func createButtonTaped(_ sender: UIButton) {
        view.endEditing(true)
     
        if selectedImage == nil {
            print("Bitte foto wählen")
            return
        }
           
        guard let image = selectedImage else {return}
        guard let imageData = image.jpegData(compressionQuality: 0.1)
        else {return}
        AuthenticationService.createUser(username: userNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess:  {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            self.performSegue(withIdentifier: "registration", sender: nil)
        }) { (error) in
            print (error!)
            
        }

        
    }
    
   
    
    
    
    //MARK NAVIGATION
    
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    
    }
    
    
    
    
    
    
    
    
    
    
    
}
