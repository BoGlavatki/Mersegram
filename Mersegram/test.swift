//
//  ShareViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 22.03.22.
//

import UIKit

class SshareViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Outlet
    
   
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var Abbrechen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToImageView()
        
        // Do any additional setup after loading the view.
   
    
    }
    
    
    
    //MARK: Choose post
    func addTapGestureToImageView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto))
        postImage.addGestureRecognizer(tapGesture)
        postImage.isUserInteractionEnabled = true
    
    }
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.cropRect]as? UIImage {
            postImage.image = editImage
        }else if let originalImage = info[.originalImage] as? UIImage{
            postImage.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        print("Share")
    }
    
    
    @IBAction func abbrechenButtonTapped(_ sender: UIButton) {
        print("Abort")
    }
    
    
    
    
    
    
    
    
    
    
    
}
