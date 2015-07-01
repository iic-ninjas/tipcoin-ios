//
//  GroupVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class GroupViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  
  @IBAction func showMenu(sender: AnyObject) {
  }
  
  @IBAction func shareInvite(sender: AnyObject) {
  }
  
  var group: Group? {
    didSet {
      if let group = group {
        self.navigationItem.title = group.name
      }
    }
  }
}

extension GroupViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MEMBER_CELL", forIndexPath: indexPath) as! UITableViewCell
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
}