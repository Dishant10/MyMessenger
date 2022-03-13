//
//  AppDelegate.swift
//  MyMessenger
//
//  Created by Dishant Nagpal on 03/03/22.
//

// AppDelegate.swift
import UIKit
import FBSDKCoreKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    ApplicationDelegate.shared.application(
        application,
        didFinishLaunchingWithOptions: launchOptions
    )
    
    
    FirebaseApp.configure()
    
    return true
}
      
func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
) -> Bool {
    ApplicationDelegate.shared.application(
        app,
        open: url,
        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
        annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    )
    
   return true
}
}
