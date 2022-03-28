//
//  RegistrationViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 19.03.22.
//

import UIKit

 
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
    // MARK: - Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        
        haveAnAccountButton.setAttributedTitle(attributetText, for: UIControl.State.normal)
    
    
    }
    
    func addTargetToTextField(){
        
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    @objc func textFieldDidChange(){
        let isText = userNameTextField.text?.count ?? 0 > 0 && emailTextField.text?.count ??
        0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
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
     
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] (data, error) in
            if let err = error{
                print(err.localizedDescription)
                return
            }
         
            guard let newUser = data?.user else{ return }
            let uId = newUser.uid
            print("User: ", newUser.email , " ID: ", uId)
           
            self.uploadUserData(uid: uId, username:  self.userNameTextField.text!, email: self.emailTextField.text!)
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
           
            
        }
        
    }
    
    
    func uploadUserData(uid: String, username: String, email: String){
        
        let storageRef = Storage.storage().reference().child("profile_image").child(uid)//DIESE METHODE GEHT IN SPEICHER - AUF WEB SEITE - UND SPEICHERT DORT DEN PROFILEDATEN
      
       
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.1) else { return }//BILD WIRD COMPRIMIERT DA BRAUCHT MAN NICHT GROß für profilfoto
        
        storageRef.putData(uploadData, metadata: nil){
            (metadata, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in//PHYSIKALISCHE BILD IN STORAGE SPEICHERN
                if error != nil{
                    print(error?.localizedDescription)
                    return
                }
                let profilImageUrlString = url?.absoluteString
                print(profilImageUrlString!)
                
                
                //ADRESSE IN DATENBANK HINZUFÜGEN
                let ref = Database.database(url: "https://mersegram-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users").child(uid)
                ref.setValue(["username": self.userNameTextField.text!, "email": self.emailTextField.text!, "profilImageURL" : profilImageUrlString ?? "kein Bild vorhanden"])
                
               
            })
        }
        
       
        
       // let storageRef = Storage.storage().reference().child("profil_image").child(uid)
       
        
        
        
    }
    
    
    
    //MARK NAVIGATION
    
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    
    }
    
    
    
    
    
    
    
    
    
    
    
}
