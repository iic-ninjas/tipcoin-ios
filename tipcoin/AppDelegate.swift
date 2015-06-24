//
//  AppDelegate.swift
//  tipcoin
//
//  Created by Wertheimer, Udi on 6/10/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Parse.setApplicationId("8BhP3CPxuMhtKpSNrsS61XkXYliBccBDqkum5clm", clientKey: "Ls5bQdEyhIeTbLSooSYICtXmFjOCWhW9QHu70DPM")
    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(nil, block: nil)
    return true
  }
  
  func application(application: UIApplication,
    openURL url: NSURL,
    sourceApplication: String?,
    annotation: AnyObject?) -> Bool {
      return FBSDKApplicationDelegate.sharedInstance().application(application,
        openURL: url,
        sourceApplication: sourceApplication,
        annotation: annotation)
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    FBSDKAppEvents.activateApp()
  }


}

