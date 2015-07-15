//
//  AppDelegate.swift
//  tipcoin
//
//  Created by Wertheimer, Udi on 6/10/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import SwiftyDrop

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Parse.setApplicationId("8BhP3CPxuMhtKpSNrsS61XkXYliBccBDqkum5clm", clientKey: "Ls5bQdEyhIeTbLSooSYICtXmFjOCWhW9QHu70DPM")
    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(nil, block: nil)
    Member.initialize()
    Group.initialize()
    Transaction.initialize()
    
    // Register for Push Notitications
    if application.applicationState != UIApplicationState.Background {
      // Track an app open here if we launch with a push, unless
      // "content_available" was used to trigger a background push (introduced in iOS 7).
      // In that case, we skip tracking here to avoid double counting the app-open.
      
      let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
      let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
      var pushPayload = false
      if let options = launchOptions {
        pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
      }
      if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
      }
    }
    if application.respondsToSelector("registerUserNotificationSettings:") {
      let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
      let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
      application.registerUserNotificationSettings(settings)
      application.registerForRemoteNotifications()
    } else {
      let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
      application.registerForRemoteNotificationTypes(types)
    }
    
    return true
  }
  
  func application(application: UIApplication,
    openURL url: NSURL,
    sourceApplication: String?,
    annotation: AnyObject?) -> Bool {
      if url.scheme == "tipcoin" && url.host == "invite"{
        let groupId = url.path?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "/"))
        let inviteToken = url.fragment
        
        InviteManager.sharedInstance.receivedInviteWithGroupId(groupId, inviteToken: inviteToken)
        if let user = PFUser.currentUser() {
          InviteManager.sharedInstance.joinGroup() { group, err in
          }
        }
        
        return true
      }
      return FBSDKApplicationDelegate.sharedInstance().application(application,
        openURL: url,
        sourceApplication: sourceApplication,
        annotation: annotation)
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    FBSDKAppEvents.activateApp()
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let installation = PFInstallation.currentInstallation()
    installation.setDeviceTokenFromData(deviceToken)
    installation.saveInBackground()
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    if error.code == 3010 {
      println("Push notifications are not supported in the iOS Simulator.")
    } else {
      println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    PFPush.handlePush(userInfo)
    if application.applicationState == UIApplicationState.Inactive {
      PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    }
  }


}

