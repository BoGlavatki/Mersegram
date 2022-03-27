//
//  HomeViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 22.03.22.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan

        // Do any additional setup after loading the view.
    }
    

    //MARK - LOGOUT BUTTON ACTION

    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        do{
          try  Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError.localizedDescription)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
        present(loginVC, animated: true, completion: nil)
}
}
