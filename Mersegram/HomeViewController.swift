//
//  HomeViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 22.03.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    
//MARK: - OUTLET
    @IBOutlet weak var tableView: UITableView!
    //MARK: var/let
    
    var posts = [PostModel]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()

        // Do any additional setup after loading the view.
    }
    //MARK: LOAD POSTS - hier werden posts aus dem Datenbase geladen

    func loadPosts(){
        let refDataasePosts = Database.database(url: "https://mersegram-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("posts")
        print(refDataasePosts)
        
        refDataasePosts.observe(.childAdded) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let newPost = PostModel(dictionary: dic)
            
            guard let userUid = newPost.uid else { return }
            self.fetchUser(uid: userUid, completed: {
                self.posts.append(newPost)
              //  self.posts.insert(newPost, at: 0)
             //   self.activtixIndicatorView.stopAnimating()
                self.tableView.reloadData()
                //self.tableView.setContentOffset(CGPoint.zero, animated: true)
            })
        }
    }
    
    
    //MARK: - Fetch users - bekomme diese user
    func fetchUser(uid: String, completed: @escaping () -> Void){
        let refDatabaseUser = Database.database(url:"https://mersegram-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users").child(uid)
        
        refDatabaseUser.observe(.value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let newUser = UserModel(dictionary: dic)
            self.users.append(newUser)
            completed() // Der Block { } welcher als Parameter an fetchUser() übergeben wird, wird an dieser Stelle aufgerufen
        }
    }
    
    //MARK - LOGOUT BUTTON ACTION

    @IBAction func logoutButtonTapped(_ sender: Any) {
        AuthenticationService.logOut(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
            self.present(loginVC, animated: true, completion: nil)
        }) {
        (error) in
            print(error!)
        }
    }
 
}
//MARK: TABLEVIEW DATASOURCE
//ERWEITERUNG HOMEVIEW COTROLLER
extension HomeViewController: UITableViewDataSource{
    
    //RÜCKGABE WERT ANZAHL ZEILE 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    //WIEDERVERWENDBAR ZEILE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
       
        cell.post = posts[indexPath.row]
        
        cell.user = users[indexPath.row]
       // cell.postTextLabel.text = posts[indexPath.row].postText
        
        return cell //JEdes mal wird zeile Post gemacht und so oft bis alle Posts
    }
}
