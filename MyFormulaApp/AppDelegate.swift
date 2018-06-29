//
//  AppDelegate.swift
//  MyFormulaApp
//
//  Created by Apple on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import GoogleMobileAds

import Alamofire
import SwiftyJSON
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.setStatusBarBackgroundColor = UIColor.white


        
        //-------------------------------- Making app register for Remotw Notification --------------------------------------
        
        if #available(iOS 10.0, *) {
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
            
            
        } else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        
        application.registerForRemoteNotifications()
        
        //-------------------------------------------------------------------------------------------------------------------
        
        
        FirebaseApp.configure()
 
        //GADMobileAds.configure(withApplicationID: "ca-app-pub-9129713665694143/8673828143")
        
        return true
    }
    
    
    
    
    
    //--------------------------------------- Push Notification module Start ---------------------------------------------------------------------------------------------------
    
    
    //To get Device Token or Firebase Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // FCM Token
        if let refreshedToken = InstanceID.instanceID().token(){
            print("InstanceID token: \(refreshedToken)")
            
            //let device_id = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            //print("The device Token is = \(device_id)")
           
            userDefault.set(refreshedToken, forKey: DeviceToken)
            
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            
            let splashViewController = story.instantiateViewController(withIdentifier: "splashViewController") as! SplashViewController
            
            self.window?.rootViewController = splashViewController
            
        }
        connectToFcm()
        
    }
    
    func connectToFcm() {
        
        Messaging.messaging().connect{ (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
                
            } else {
                print("Connected to FCM.")
               
            }
        }
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
        
        userDefault.set(fcmToken, forKey: DeviceToken)
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        
        let splashViewController = story.instantiateViewController(withIdentifier: "splashViewController") as! SplashViewController
        
        self.window?.rootViewController = splashViewController
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        print(JSON(userInfo))
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Print full message.
        print(JSON(userInfo))
        
    }
    
    
    //Called if unable to register for APNS.
    private func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        let aps = userInfo["gcm.notification.data"] as? String
        // print(aps)
        
        let data = aps?.data(using: .utf8)
        
        var jsonDictionary : NSDictionary = [:]
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
        } catch {
            print(error)
        }
        print("Notification Data is:\(jsonDictionary)")
        
        let strType = jsonDictionary["notification_from"] as? String
        if strType == "receive_message"{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageNotification"), object: jsonDictionary)
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification"), object: jsonDictionary)
        }
        
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    //--------------------------------------- Push Notification module End ---------------------------------------------------------------------------------------------------
    
    
    
    
    
    
    

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

