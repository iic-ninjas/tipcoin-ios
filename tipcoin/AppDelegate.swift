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
            if let group = group as? Group {
              Drop.down("You just joined group \"\(group.name)\"", blur: .Dark)
              NSNotificationCenter.defaultCenter().postNotificationName("JOINED_GROUP", object: group)
            }
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


}

