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
    var uid: String?// user id welcher den Post gemacht hat
    var id: String?// Post ID  von dem Post selbst
    init( dictionary: [String: Any], key: String ){
        
        postText = dictionary["postText"] as? String
        imageUrl = dictionary ["imageUrl"] as? String
        uid = dictionary["uid"] as? String
        id = key
    }
    
    
    
}
