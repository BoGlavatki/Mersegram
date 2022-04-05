//
//  CommentMode.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 05.04.22.
//

import Foundation
class CommentModel{
    var commentText: String?
    var uid: String?
    
    init(dictionary: [String: Any]){
        commentText = dictionary["commentText"] as? String
        uid = dictionary["uid"] as? String
    }
    
}
