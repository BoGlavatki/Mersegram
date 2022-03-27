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


class AuthenticationService{

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
    
        //MERKE - Registratio
    
}


