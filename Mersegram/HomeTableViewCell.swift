//
//  HomeTableViewCell.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 30.03.22.
//

import UIKit
import SDWebImage

protocol HomeTableViewCellDelegate{
    func didTapCommentImageView()
}

class HomeTableViewCell: UITableViewCell {
//MARK: - OUTLET
    
    
    
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postTextLabel: UILabel!
    
    
    
    //MARK: - Post
    var post: PostModel? {
        didSet{
            guard let _posText = post?.postText else { return }
            guard let _imageUrl = post?.imageUrl else { return }
            print("****POSTIMAGE URL: ", _imageUrl)
            updateCellView(postText: _posText, imageUrl: _imageUrl)
            
        }
    }
    
    func updateCellView(postText: String, imageUrl: String){
        postTextLabel.text = postText
        
        guard let url = URL(string: imageUrl) else { return }
        postImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
        
    }
    
    
    //MARK: - USER
    var user: UserModel? {
        didSet {
            
            guard let _username = user?.username else {print("kein username")
                return }
            print("USERNAME", _username)
            guard let _profilImage = user?.profilImageUrl else { print("kein imageprof")
                return }
            setupUserInfo(username: _username, profilImage: _profilImage)
        }
    }
    
    func setupUserInfo(username: String, profilImage: String){
      
        nameLabel.text = username
        guard let url = URL(string: profilImage) else { return }
        profilImageView.sd_setImage(with: url) { (_, _, _, _) in
            
        }
        }
    
    //MARK: -Navigation to CommentViewController/ Übergang
    var homeViewController: HomeTableViewCellDelegate?//HIER WIRD EINE REFERENZ VOM HOMEVIEWCONTROLLER GESPEICHERT WERDEN
    
    
    func addTapGestureToImageView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapComment))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleDidTapComment(){
     print("HAT GEKLAPT!")
        
       homeViewController?.didTapCommentImageView()//ÜBERGANG ZU KOMMENAARE
    }
    
    
    //MARK: - Cell awake / Wenn die ZEile erstellt wird
    override func awakeFromNib() {
        super.awakeFromNib()
        profilImageView.layer.cornerRadius = profilImageView.frame.width / 2
        addTapGestureToImageView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        profilImageView.image = UIImage(named: "placeholder")
    }

}
