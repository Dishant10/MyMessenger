//
//  ViewController.swift
//  MyMessenger
//
//  Created by Dishant Nagpal on 03/03/22.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {
    
//    private let tableView:UITableView={
//       let table=UITableView()
//        
//        return table
//    }()
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth(){
        
        if FirebaseAuth.Auth.auth().currentUser==nil{
            let vc=LoginViewController()
            let nav=UINavigationController(rootViewController: vc)
            // nav.isNavigationBarHidden=false
            //nav.navigationBar.backgroundColor = .white
            
            nav.modalPresentationStyle = .fullScreen
            present(nav,animated: false)
        }
        
    }
}
