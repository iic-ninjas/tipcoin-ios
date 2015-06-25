//
//  MenuVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class MenuViewController: UIViewController {
  
  @IBOutlet weak var avatarView: UIImageView!
  
  @IBAction func logOut(sender: AnyObject) {
    PFUser.logOut()
    performSegueWithIdentifier("back", sender: nil)
  }
  
  @IBAction func closeMenu(sender: AnyObject) {
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let user = PFUser.currentUser() {

      if let urlString = user["avatarUrl"] as? String,
         let avatarURL = NSURL(string: urlString + "?type=large") {
          avatarView.sd_setImageWithURL(avatarURL, placeholderImage: UIImage(named: "default-avatar"))
      }
      
    }
  }
}