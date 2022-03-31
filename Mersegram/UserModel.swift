//
//  UserModel.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 31.03.22.
//

import Foundation

class UserModel{
    
    
    var username: String?
    var email: String?
    var profilImageUrl: String?
    
    init (dictionary: [String: Any]){
        
        username = dictionary["username"] as? String
        email = dictionary ["email"] as? String
        profilImageUrl = dictionary["profilImageURL"] as? String
        
        
    }
    
}
