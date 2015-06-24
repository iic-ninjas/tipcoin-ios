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
      loadData()
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
//    PFUser.
  }
}