//
//  AppDelegate.swift
//  bcsv.org
//
//  Created by Haksoo Kim on 7/28/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
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
        // Override point for customization after application launch.
        // When the app launch after user tap on notification (originally was not running / not in background)
        //If the app is not running / not in background and user tap on the notification , the app will be launched.

        if(launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil){
            // your code here
            UIApplication.shared.applicationIconBadgeNumber += 1
            print(launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] ?? "none")
        }
        
        return true
    }

    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        UIApplication.shared.applicationIconBadgeNumber += 1
        print("Message ID: \(messageID)")
      }
    }

    // This function is called when user tapped on the message
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
        print("*Message ID: \(messageID)")
        }
        
        print("*** SOM2")
        if let aps = userInfo["aps"] as? NSDictionary {
              if let alert = aps["alert"] as? NSDictionary {
                
                let alertController = UIAlertController(title: alert["title"] as? String, message: alert["body"] as? String, preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    NSLog("OK Pressed")
                                }
                alertController.addAction(okAction)
                
                // This is required for iPad. Otherwise the app will crash on iPad
                if let popoverController = alertController.popoverPresentationController {
                    //popoverController.barButtonItem = sender
                    popoverController.sourceView = self.window
                    popoverController.sourceRect = CGRect(x: self.window!.bounds.midX, y: self.window!.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    
                if UIApplication.shared.applicationIconBadgeNumber > 0{
                    UIApplication.shared.applicationIconBadgeNumber -= 1
//                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let mainView = mainStoryboard.instantiateViewController(withIdentifier: "Main_SB") as! MainViewController
//                    self.window?.rootViewController = mainView
//                    mainView.lblNotificationNumber.text = String(UIApplication.shared.applicationIconBadgeNumber)
                }
              }
        }

        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    /*
     Receive displayed notifications for iOS 10 devices.
     This function will be called when the app receives notification when it is in foreground.
    */
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        // let userInfo = notification.request.content.userInfo
        UIApplication.shared.applicationIconBadgeNumber += 1

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.mobile.bcsv.org.badgeWasUpdated"), object: nil)
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        //show the notification alert (banner), and with sound
        completionHandler([.alert, .sound])
    }
    
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("APNs token retrieved: \(deviceToken)")

      // With swizzling disabled you must set the APNs token here.
      // Messaging.messaging().apnsToken = deviceToken
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

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
      print("Just received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

