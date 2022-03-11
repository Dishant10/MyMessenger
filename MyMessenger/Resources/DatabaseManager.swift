//
//  DatabaseManager.swift
//  MyMessenger
//
//  Created by Dishant Nagpal on 09/03/22.
//

import Foundation
import FirebaseDatabase
final class DatabaseManager{
    
    static let shared = DatabaseManager()
    private let database=Database.database().reference()
    
}
//MARK:- Account Managment

extension DatabaseManager{
    
    
    
    public func userExists(with email:String,completion:@escaping (Bool)->Void ){
        
        var safeEmail=email.replacingOccurrences(of: ".", with: "-")
        safeEmail=safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard let foundEmail=snapshot.value as? String else{
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    /// Inserts new user to database.
    
    public func inserUser(with user:ChatAppUser){
        database.child(user.safeEmail).setValue([
             "firstName":user.firstName,
             "lastName":user.lastName
        ])
    }
}

struct ChatAppUser{
    
    let firstName:String
    let lastName:String
    let email:String
    var safeEmail:String{
        var safeEmail=email.replacingOccurrences(of: ".", with: "-")
        safeEmail=safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
//    let profilePictureURL:String
}

