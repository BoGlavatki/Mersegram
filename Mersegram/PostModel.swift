//
//  PostModel.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 30.03.22.
//

import Foundation

class PostModel{
    
    var postText: String?
    var imageUrl: String?
    var uid: String?
    
    init( dictionary: [String: Any] ){
        
        postText = dictionary["postText"] as? String
        imageUrl = dictionary ["imageUrl"] as? String
        uid = dictionary["uid"] as? String
        
    }
    
    
    
}
