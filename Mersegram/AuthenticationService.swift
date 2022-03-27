//
//  AuthenticationService.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 23.03.22.
//

import Foundation

import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class AuthenticationService {

    //MARK: -  Einloggen
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            print(data?.user.email ?? "")
            onSuccess() // Der übergebende Closure wird beim erfolgreichen einloggen ausgeführt
        }
    }
    
        //MERKE - Registration
    
    static func createUser (username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) ->Void){
        
        Auth.auth().createUser(withEmail: email, password: password){(data, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            //WENN USER ERFOLGREICH ERSTELLTWÜRDE
            guard let uid = data?.user.uid else{ return }
            self.uploadUserData(uid: uid, username: username, email: email, imageData: imageData, onSuccess: onSuccess)
            
            
        }
        
    }
    


    static func uploadUserData(uid: String, username: String, email: String, imageData: Data, onSuccess: @escaping () -> Void){
        
    
    let storageRef = Storage.storage().reference().child("profile_image").child(uid)
  
   
    
    storageRef.putData(imageData, metadata: nil){
        (metadata, error) in
        if let err = error {
           
            return
        }
        storageRef.downloadURL(completion: { (url, error) in//PHYSIKALISCHE BILD IN STORAGE SPEICHERN
            if error != nil{
             return
            }
            let profilImageUrlString = url?.absoluteString
            print(profilImageUrlString!)
            
            
            //ADRESSE IN DATENBANK HINZUFÜGEN
            let ref = Database.database(url: "https://mersegram-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users").child(uid)
            ref.setValue(["username": username, "email": email, "profilImageURL" : profilImageUrlString ?? "kein Bild vorhanden"])
            
         
            
           
        })
    }
    
   
    
   // let storageRef = Storage.storage().reference().child("profil_image").child(uid)
   
    
    
    
}
}
