//
//  NewGroupVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/8/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class NewGroupViewController: UIViewController {
  
  @IBOutlet weak var groupName: UITextField!
  @IBOutlet weak var spinnerView: Spinner!
  @IBOutlet weak var button: UIButton!
  
  @IBAction func createGroup(sender: AnyObject) {
    let name = groupName.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    if !name.isEmpty {
      disable()
      CreateGroupOperation.run(name) { [weak self] group, err in
        if err != nil {
          println(err)
        } else {
          self?.performSegueWithIdentifier("backToMenu", sender: nil)
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    groupName.becomeFirstResponder()
  }
  
  func disable(){
    button.enabled = false
    spinnerView.spin()
    groupName.enabled = false
  }
  
}