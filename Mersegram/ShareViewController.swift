//
//  ShareViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 22.03.22.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class ShareViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    //MARK: var/LET
    
    var selectedImage: UIImage?
    
    //MARK: - VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        navigationItem.title = "SHARE"
        
        addTapGestureToImageView()
        handleShareAndAbortButton()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - VIEW LIFECYLCE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageDidChange()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    //MARK: - CHOOSE PHOTO
    func addTapGestureToImageView(){
        let tapedGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto))
        postImageView.addGestureRecognizer(tapedGesture)
        postImageView.isUserInteractionEnabled = true
    }
    
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.modalPresentationStyle = .fullScreen
        present(pickerController, animated: true, completion: nil)
    }
    
    
    
    // MARK: View stuff
    func handleShareAndAbortButton() {
        sharedButton.isEnabled = false
        abortButton.isEnabled = false
        
        let attributeShareButtonText = NSAttributedString(string: (sharedButton.titleLabel?.text!)!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)])
        let attributeAbortButtonText = NSAttributedString(string: (abortButton.titleLabel?.text!)!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)])
        
        sharedButton.setAttributedTitle(attributeShareButtonText, for: .normal)
       abortButton.setAttributedTitle(attributeAbortButtonText, for: .normal)
    }
    
    //MARK: - BUTTONS WIEDER FUNKTIONSFAHIG
    func imageDidChange(){
        
        let isImage = selectedImage != nil
        
        if isImage {
        sharedButton.isEnabled = true
        abortButton.isEnabled = true
        
        let attributeShareButtonText = NSAttributedString(string: (sharedButton.titleLabel?.text!)!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)])
        let attributeAbortButtonText = NSAttributedString(string: (abortButton.titleLabel?.text!)!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)])
        
        sharedButton.setAttributedTitle(attributeShareButtonText, for: .normal)
       abortButton.setAttributedTitle(attributeAbortButtonText, for: .normal)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editImage = info[.cropRect] as? UIImage{
            postImageView.image = editImage
            selectedImage = editImage
        }else if let originalImage = info[.originalImage] as? UIImage{
            postImageView.image = originalImage
            selectedImage = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
     
    
    
    
    
    //MARK: Post
    
    @IBAction func sharedButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        ProgressHUD.show("Lade...", interaction: false)
        
        guard let image = selectedImage else {return}
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return}
        let imageId = NSUUID().uuidString //JEDES Foto erhält
        
        let storageRef = Storage.storage().reference().child("posts").child(imageId)
        storageRef.putData(imageData, metadata: nil){ (metadata, error)in
            if error != nil {
                ProgressHUD.showError("Das Bild kann nicht hochgeladen werden")
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                let profilImageUrlString = url?.absoluteString
                self.uploadDataToDatabase(imageUrl: profilImageUrlString ?? "Kein Bild vorhanden")
            })
        }
    }
    
    func uploadDataToDatabase(imageUrl: String){
        let databaseRef = Database.database(url: "https://mersegram-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("posts")
        let newPostId = databaseRef.childByAutoId().key
        let newPostRefernce = databaseRef.child(newPostId!)
        
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        
        let dic = ["uid" : userUid, "imageUrl" : imageUrl, "postText": postTextView.text] as [String: Any]
        newPostRefernce.setValue(dic) { (error, ref)in
            if error != nil {
                ProgressHUD.showError("Fehler, Daten konnten nicht hochgeladen werden")
                return
            }
            ProgressHUD.showSuccess("Post erstellt")
            
            self.remove()
            self.handleShareAndAbortButton()
            self.tabBarController?.selectedIndex = 0
        }
    }

    @IBAction func abortButtonTapped(_ sender: UIButton) {
        remove()
        handleShareAndAbortButton()
    }
    
    func remove(){
        selectedImage = nil
        postTextView.text = ""
        postImageView.image = UIImage(named: "placeholder")
    }
}
