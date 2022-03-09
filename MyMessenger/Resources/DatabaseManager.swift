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
        database.child(email).observeSingleEvent(of: .value) { snapshot in
            guard let foundEmail=snapshot.value as? String else{
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    /// Inserts new user to database.
    
    public func inserUser(with user:ChatAppUser){
        database.child(user.email).setValue([
             "firstName":user.firstName,
             "lastName":user.lastName
        ])
    }
}

struct ChatAppUser{
    
    let firstName:String
    let lastName:String
    let email:String
//    let profilePictureURL:String
}

