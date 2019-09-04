//
//  AppDelegate.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var User = [AllUserModel]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
//        let badge = (userInfo["badge"] as! Int)
//        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
        if let messageId = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageId)")
        }
        print(userInfo)

        let dictionary = ["email": userInfo["email"], "uid": userInfo["uid"], "profileImageUrl": userInfo["profileImageUrl"], "username": userInfo["username"], "fullname": userInfo["fullname"], "pushToken": userInfo["pushToken"], "notifications": ["showPreview": userInfo["showPreview"]]]
        let user = AllUserModel()
        user.setValuesForKeys(dictionary as [String : Any])
        self.User.append(user)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let presentVC = storyboard.instantiateViewController(withIdentifier: "NavigationChat") as! UINavigationController
        let chatVC = presentVC.topViewController as! ChatViewController
        chatVC.allUser = self.User[0]
        chatVC.isfromNotification = true
        
        self.window?.rootViewController = presentVC
        self.window?.makeKeyAndVisible()
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        completionHandler(.newData)
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let uid = Auth.auth().currentUser?.uid  {
            var badges = 0
            UIApplication.shared.applicationIconBadgeNumber = badges
            Ref().databaseRoot.child("user-messages").child(uid).observe(.childAdded, with: { (snapshot) in
                let toUid = snapshot.key
                Ref().databaseRoot.child("user-messages").child(uid).child(toUid).observe(.childAdded, with: { (dataSanpshot) in
                    let messageId = dataSanpshot.key
                    Ref().databaseRoot.child("messages").child(messageId).observe(.value, with: { (messageSnapshot) in
                        if let dict = messageSnapshot.value as? [String:Any] {
                            let read = dict["read"] as! Int
                            let toId = dict["toUid"] as! String
                            if toId == uid {
                                if read == 1 {
                                    badges += 1
                                    UIApplication.shared.applicationIconBadgeNumber = badges
                                }
                            }
                        }
                    })
                })
            })
        }
//        let uid = Auth.auth().currentUser?.uid
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

