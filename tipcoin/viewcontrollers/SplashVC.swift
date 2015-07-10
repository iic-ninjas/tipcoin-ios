//
//  splash.swift
//  tipcoin
//
//  Created by Bergman, Yon on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation
import ParseFacebookUtilsV4

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
    } else {
      showLogin()
    }
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
    PFFacebookUtils.logInInBackgroundWithReadPermissions([]) {
      (user: PFUser?, error: NSError?) -> Void in
      if let user = user {
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
      let firstName = result["first_name"] as! String
      let lastName = result["last_name"] as! String
      let displayName = result["name"] as! String
      let fbId = result["id"] as! String
      let avatarUrl = "http://graph.facebook.com/\(fbId)/picture"
      
      let userInfo = UserInfo(firstName: firstName, lastName: lastName, displayName: displayName, avatarUrl: avatarUrl)
      UpdateUserOperation().run(userInfo) { result,err in
        if let user = result as? PFUser {
          
        }
      }
      if let user = PFUser.currentUser() {
        if user["avatarUrl"] == nil {
          user.fetchInBackground()
        }
      }
      if InviteManager.sharedInstance.hasInvite() {
        InviteManager.sharedInstance.joinGroup() { group, err in
          if let group = group as? Group {
          let vc = UIAlertController(title: "Joined Group", message: "Successfully join the group \"\(group.name)\"", preferredStyle: UIAlertControllerStyle.Alert)
            vc.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { _ in
              self.navigateToMenu()
            }))
            self.presentViewController(vc, animated: true, completion: nil)
          } else {
            self.navigateToMenu()
          }
        }
      } else {
        self.navigateToMenu()
      }

    }
  }
  
  private func navigateToMenu() {
    self.performSegueWithIdentifier("showMenu", sender: nil)
  }
  
  @IBAction func goToSideMenu(segue: UIStoryboardSegue) {
    startLoading()
  }

}