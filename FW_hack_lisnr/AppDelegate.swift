//
//  AppDelegate.swift
//  Koloda
//
//  Created by Eugene Andreyev on 07/01/2015.
//  Copyright (c) 07/01/2015 Eugene Andreyev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LISNRContentManagerDelegate  {

    var window: UIWindow?
    var currentContent: [String:AnyObject] = Dictionary()
    var alertView: UIAlertView?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if(UIApplication.instancesRespondToSelector(#selector(UIApplication.registerUserNotificationSettings(_:)))) {
            // iOS 8+
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        backgrounded = true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        backgrounded = false
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func didReceiveContent(content: LISNRBaseContentProtocol, forIDToneWithId toneId: UInt) {
        
        print("Did receive content")
        
        if(backgrounded!) {
            self.presentNotificationForContent(content)
        } else {
//                    if let videoContent = content as? LISNRVideoContentProtocol {
//                        self.handleVideoContent(videoContent)
//                    } else if let imageContent = content as? LISNRImageContentProtocol {
//                        self.handleImageContent(imageContent)
//                    } else if let webContent = content as? LISNRWebContentProtocol {
//                        self.handleWebContent(webContent)
//                    } else if let notificationContent = content as? LISNRNotificationContentProtocol {
//                        self.handleNotificationContent(notificationContent)
//                    }
                }
    }
    
    
    func presentNotificationForContent(content: LISNRBaseContentProtocol) {
        let localNotification = UILocalNotification()
        localNotification.alertBody = content.contentTitle()
        
        // Create a unique key for the content and store it in the dictionary
        // We need to access the content in the didReceiveLocalNotification function
        // and the userInfo property only accepts primitives as values
        // so we crate a reference to the content by a unique identifier
        //
        // Note: This will only work if the content is memory, if the local notification is launched after the app terminates
        // no content will be shown
        //
        let uuid:String = NSUUID().UUIDString
        currentContent[uuid] = content
        
        // Add the unique key to the notification
        localNotification.userInfo = ["uuid":uuid]
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
    }


}

