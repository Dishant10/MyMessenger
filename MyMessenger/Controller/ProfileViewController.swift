//
//  ProfileViewController.swift
//  MyMessenger
//
//  Created by Dishant Nagpal on 03/03/22.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    
    let data=["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate=self
        tableView.dataSource=self
        
    }
    
    
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text=data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert=UIAlertController(title: "Log out!!" ,
                                    message: "Do you want to really log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive) { [weak self] alertAction in
            
            guard let strongSelf=self else{
                return
            }
            
            // Log out of Facebook
            
            FBSDKLoginKit.LoginManager().logOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                let vc=LoginViewController()
                let nav=UINavigationController(rootViewController: vc)
                
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav,animated: true)
            }catch{
                print("Failed to log out.")
            }
            
        }
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert,animated: true)
    }
}
