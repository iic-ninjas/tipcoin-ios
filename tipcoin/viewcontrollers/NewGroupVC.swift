//
//  NewGroupVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/8/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation
import SwiftyDrop


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
          if let group = group as? Group {
            Drop.down("Successfully created new group \"\(group.name)\"", state: .Success)
          }

          self?.performSegueWithIdentifier("backToMenu", sender: group)
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