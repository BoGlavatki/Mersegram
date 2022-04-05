//
//  CommentTableViewCell.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 01.04.22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

   
    
    //MARK: OUtlet
    @IBOutlet weak var profilImageView: UIImageView!
  
    @IBOutlet weak var commentTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
