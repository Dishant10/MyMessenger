//
//  RegisterViewController.swift
//  MyMessenger
//
//  Created by Dishant Nagpal on 03/03/22.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView=UIScrollView()
        scrollView.clipsToBounds=true
        return scrollView
    }()
    
    private let firstNameField:UITextField={
        let firstNameField=UITextField()
        firstNameField.textColor = .black
        firstNameField.autocapitalizationType = .none
        firstNameField.autocorrectionType = .no
        firstNameField.returnKeyType = .continue
        firstNameField.layer.cornerRadius=12
        firstNameField.layer.borderWidth=1
        firstNameField.layer.borderColor=UIColor.lightGray.cgColor
        firstNameField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        firstNameField.leftViewMode = .always
        firstNameField.backgroundColor = .white
        firstNameField.placeholder="First Name.."
        
        return firstNameField
    }()
    
    
    private let lastNameField:UITextField={
        let lastNameField=UITextField()
        lastNameField.textColor = .black
        lastNameField.autocapitalizationType = .none
        lastNameField.autocorrectionType = .no
        lastNameField.returnKeyType = .continue
        lastNameField.layer.cornerRadius=12
        lastNameField.layer.borderWidth=1
        lastNameField.layer.borderColor=UIColor.lightGray.cgColor
        lastNameField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        lastNameField.leftViewMode = .always
        lastNameField.backgroundColor = .white
        lastNameField.placeholder="Last Name..."
        
        return lastNameField
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
    
    private let registerButton:UIButton={
        let registerButton=UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.layer.cornerRadius=12
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.masksToBounds=true
        registerButton.titleLabel?.font = .systemFont(ofSize: 20, weight : .bold)
        
        return registerButton
    }()
    private var imageView:UIImageView={
        let imageView=UIImageView()
        imageView.image=UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.layer.masksToBounds=true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth=2
        imageView.layer.borderColor=UIColor.lightGray.cgColor
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title="Log In.."
        view.backgroundColor = .white
        //        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Register",
        //                                                          style: .done,
        //                                                          target: self,
        //                                                          action: #selector(didTapRegister))
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate=self
        passwordField.delegate=self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField )
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        imageView.isUserInteractionEnabled=true
        scrollView.isUserInteractionEnabled=true
        let gesture=UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame=view.bounds
        let size=scrollView.width/3
        imageView.frame=CGRect(x: (scrollView.width-size)/2,
                               y: 70,
                               width: size,
                               height: size)
        
        imageView.layer.cornerRadius=imageView.width/2.0
        
        firstNameField.frame=CGRect(x: 30,
                                    y: imageView.bottom+30,
                                    width: scrollView.width-60,
                                    height: 52)
        lastNameField.frame=CGRect(x: 30,
                                   y: firstNameField.bottom+20,
                                   width: scrollView.width-60,
                                   height: 52)
        emailField.frame=CGRect(x: 30,
                                y: lastNameField.bottom+20,
                                width: scrollView.width-60,
                                height: 52)
        
        passwordField.frame=CGRect(x: 30,
                                   y: emailField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        
        registerButton.frame=CGRect(x: 60,
                                    y: passwordField.bottom+15,
                                    width: scrollView.width-120,
                                    height: 50)
    }
    
    @objc private func registerButtonTapped(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        guard let firstName=firstNameField.text,
              let lastName=lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              password.count>=6 else{
                  alertUserLoginError()
                  return
              }
        //Firebase Login
        
        DatabaseManager.shared.userExists(with: email) { exists in
            guard !exists else{
                //user already exists
                self.alertUserLoginError(message: "User already exists!!.Try usign with a different email address.")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf=self else{
                    return
                }
                guard authResult != nil,error == nil else{
                    fatalError("Error creating user.")
                    
                }
                DatabaseManager.shared.inserUser(with: ChatAppUser(firstName: firstName, lastName: lastName, email: email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil )
            }
            
        }
        
      
        
    }
    
    
    func alertUserLoginError(message:String = "Enter the information again."){
        let alert=UIAlertController(title: "OOPS!",
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert,animated: true)
        
        
    }
    
    
}



extension RegisterViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField==emailField{
            passwordField.becomeFirstResponder()
        }else if textField==passwordField{
            registerButtonTapped()
        }
        return true
    }
}


extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default ,
                                            handler: { [weak self]_ in
            self?.presentPhotoLibrary()
        }))
        
        present(actionSheet,animated: true)
        
    }
    
    func presentCamera(){
        let vc=UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing=true
        print("yes1")
        present(vc,animated: true)
    }
    
    func presentPhotoLibrary(){
        let vc=UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing=false
        present(vc,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("yes")
        if let selectedImage = info[.editedImage] {
            self.imageView.image=selectedImage as? UIImage
        }
        self.dismiss(animated: true, completion: { () -> Void in

                })
    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//
//    }
   
    
}

