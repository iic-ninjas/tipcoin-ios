//
//  splash.swift
//  tipcoin
//
//  Created by Bergman, Yon on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class SplashViewController: UIViewController {
  
  @IBOutlet var tiledBgView: TiledBackgroundView!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startLoading()
  }
  
  func startLoading(){
    tiledBgView.animate()
    if PFUser.currentUser() != nil {
      getUserData()
      PFUser.logOut()
    } else {
      showLogin()
    }
  }
  
  func loadData() {
    
  }
  
  func showLogin() {
    tiledBgView.stopAnimation()
    UIView.animateWithDuration(0.2, animations: {
      self.loginButton.alpha = 1
    })
  }

  @IBAction func didClickLogin(sender: AnyObject) {
    tiledBgView.animate()
    loginButton.alpha = 0
    PFFacebookUtils.logInInBackgroundWithReadPermissions(["user_about_me"]) {
      (user: PFUser?, error: NSError?) -> Void in
      if let user = user {
        if user.isNew {
          println("User signed up and logged in through Facebook!")
        } else {
          println("User logged in through Facebook!")
        }
        self.getUserData()
      } else {
        println("Uh oh. The user cancelled the Facebook login.")
      }
    }
  }
  
  func getUserData() {
    let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    request.startWithCompletionHandler() { connection, result, error in
      println(result)
      let firstName = result["first_name"] as? String
      let lastName = result["last_name"] as? String
      let displayName = result["name"] as? String
    }

  }
}