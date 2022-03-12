//
//  LoginViewController.swift
//  MyMessenger
//
//  Created by Dishant Nagpal on 03/03/22.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    
    
    private let scrollView: UIScrollView = {
        let scrollView=UIScrollView()
        scrollView.clipsToBounds=true
        return scrollView
    }()
    
    private let emailField:UITextField={
        let emailField=UITextField()
        emailField.textColor = .black
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius=12
        emailField.layer.borderWidth=1
        emailField.layer.borderColor=UIColor.lightGray.cgColor
        emailField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .white
        emailField.placeholder="Email Address..."
        
        return emailField
    }()
    
    
    private let passwordField:UITextField={
        let passwordField=UITextField()
        passwordField.textColor = .black
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.layer.cornerRadius=12
        passwordField.layer.borderWidth=1
        passwordField.layer.borderColor=UIColor.lightGray.cgColor
        passwordField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordField.leftViewMode = .always
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry=true
        passwordField.placeholder="Password..."
        
        return passwordField
    }()
    
    private let loginButton:UIButton={
        let loginButton=UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius=12
        loginButton.backgroundColor = .link
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.masksToBounds=true
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight : .bold)
        
        return loginButton
    }()
    private let imageView:UIImageView={
        let imageView=UIImageView()
        imageView.image=UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var FBloginButton=FBLoginButton()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title="Log In.."
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Register",
                                                          style: .done,
                                                          target: self,
                                                          action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailField.delegate=self
        passwordField.delegate=self
        FBloginButton.delegate=self
        FBloginButton.permissions=["public_profile","email"]
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(FBloginButton)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame=view.bounds
        let size=scrollView.width/3
        imageView.frame=CGRect(x: (scrollView.width-size)/2,
                               y: 100,
                               width: size,
                               height: size)
        
        emailField.frame=CGRect(x: 30,
                                y: imageView.bottom+20,
                                width: scrollView.width-60,
                                height: 52)
        
        passwordField.frame=CGRect(x: 30,
                                   y: emailField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        
        loginButton.frame=CGRect(x: 60,
                                 y: passwordField.bottom+15,
                                 width: scrollView.width-120,
                                 height: 50)
        
        
        FBloginButton.frame=CGRect(x: 60,
                                   y: loginButton.bottom+15,
                                   width: scrollView.width-120,
                                   height: 50)
        
        
        
    }
    
    @objc private func loginButtonTapped(){
        guard let email = emailField.text,let password = passwordField.text,!email.isEmpty,!password.isEmpty,password.count>=6 else{
            alertUserLoginError()
            passwordField.resignFirstResponder()
            emailField.resignFirstResponder()
            return
        }
        //Firebase Login
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf=self else{
                return
            }
            guard let result=authResult,error==nil else{
                fatalError("Error loggin in.")
            }
            let user=result.user
            print("Logged in: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func alertUserLoginError(){
        let alert=UIAlertController(title: "OOPS!",
                                    message: "Enter the information again.",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert,animated: true)
        
        
    }
    
    @objc private func didTapRegister(){
        let vc=RegisterViewController()
        vc.title="Create a new account!"
        //navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        navigationController?.pushViewController(vc, animated: true)
        
        //        vc.navigationController?.navigationBar.backgroundColor = .white
    }
}



extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField==emailField{
            passwordField.becomeFirstResponder()
        }else if textField==passwordField{
            loginButtonTapped()
        }
        return true
    }
}


extension LoginViewController:LoginButtonDelegate{
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //No Operation.
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        guard let token=result?.token?.tokenString else{
            print("User failed to login with user.")
            return
        }
        
        
        let facebookRequest=FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                       parameters: ["fields":"email, name"],
                                                       tokenString: token,
                                                       version: nil,
                                                       httpMethod: .get)
        
        facebookRequest.start { connection, result, error in
            guard let result=result as? [String:Any],error==nil else{
                print("Falied to make facebook graph request.")
                return
            }
            
            guard let name=result["name"] as? String,
                  let email=result["email"] as? String
            else{
                print("Error while fetching name and email results.")
                return
            }
            
            let nameComponents=name.components(separatedBy: " ")
            guard nameComponents.count==2 else{
                return
            }
            let firstName=nameComponents[0]
            let lastName=nameComponents[1]
            
            DatabaseManager.shared.userExists(with: email) { exists in
                if !exists{
                    DatabaseManager.shared.inserUser(with: ChatAppUser(firstName: firstName,
                                                                       lastName: lastName,
                                                                       email: email))
                }
                
            }
            
            let credential=FacebookAuthProvider.credential(withAccessToken: token)
            
            
            FirebaseAuth.Auth.auth().signIn(with:credential) { [weak self] authResult, error in
                guard let strongSelf=self else{
                    return
                }
                guard authResult != nil,error==nil else{
                    if let error = error{
                        
                        print("Facebook Credential login falied,MFA may be needed. \(error)")
                    }
                    return
                }
                print("Successfully loged user in.")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
            }
        }  
        
        
    }
    
    
    
    
}
