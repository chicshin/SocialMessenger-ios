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
        if let messageId = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageId)")
        }
        print(userInfo)

        let dictionary = ["email": userInfo["email"], "uid": userInfo["uid"], "profileImageUrl": userInfo["profileImageUrl"], "username": userInfo["username"], "fullname": userInfo["fullname"], "pushToken": userInfo["pushToken"], "notifications": ["showPreview": userInfo["showPreview"]]]
        let user = AllUserModel()
        user.setValuesForKeys(dictionary as [String : Any])
        self.User.append(user)
        
//        let userInfos = ["uid": userInfo["uid"]!, "profileImageUrl": userInfo["profileImageUrl"]!, "username": userInfo["username"]!]
//        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "notificationReceived"), object: nil, userInfo: userInfos))
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let presentVC = storyboard.instantiateViewController(withIdentifier: "NavigationChat") as! UINavigationController
        let chatVC = presentVC.topViewController as! ChatViewController
//        let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
        chatVC.allUser = self.User[0]
        chatVC.isfromNotification = true
        
        self.window?.rootViewController = presentVC
        self.window?.makeKeyAndVisible()
//        presentVC.pushViewController(chatVC, animated: false)
//        self.window?.rootViewController!.present(chatVC, animated: false, completion: nil)
        
//        presentVC.pushViewController(chatVC, animated: true)
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
//        let presentVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
//        presentVC.allUser = self.User[0]
//        let rootViewController = self.window!.rootViewController as! UINavigationController
////        self.window?.rootViewController = presentVC
//        rootViewController.present(presentVC, animated: true, completion: nil)
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("this one did called")
        print(userInfo)
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

