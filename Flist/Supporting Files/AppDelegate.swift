//
//  AppDelegate.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import UIKit
import UserNotifications

import FirebaseMessaging
import FirebaseDatabase
import FirebaseCore


import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UIApplication.shared.statusBarStyle = .lightContent
        
        // Register app for incoming notifications
        application.registerForRemoteNotifications()
        
        // Configure Firebase & Fabric utilities
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        Database.database().isPersistenceEnabled = true
        
        Fabric.with([Crashlytics.self])
                
        return true
    }
    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//
//        guard let dynamicLinks = DynamicLinks.dynamicLinks() else {
//            return false
//        }
//
//        let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
//            if let error = error {
//                print("HANDLE DYNAMIC LINKS ERROR: \(error.localizedDescription)")
//            } else if let lnk = dynamiclink {
//
//                if let pathComponents = lnk.url?.pathComponents { DynamicLinkController().FetchIncomingPathComponents(components: pathComponents, appDelegate: self) }
//
//            }
//        }
//
//        return handled
//
//    }

//    
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        return application(app, open: url,
//                           sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                           annotation: "")
//    }
//    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if let dynamicLink = DynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) {
//            
//            print("DYNAMIC LINK: \(dynamicLink.debugDescription)")
//            
//            return true
//        }
//        return false
//    }
//    
    // Recieve registered token for remote notifications
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
    }
    
    
    
    
}

