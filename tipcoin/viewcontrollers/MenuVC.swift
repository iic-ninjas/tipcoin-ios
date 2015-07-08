//
//  MenuVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class MenuViewController: UIViewController {
  
  @IBOutlet weak var spinnerView: Spinner!
  @IBOutlet weak var tableView: UITableView!
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
      self.spinnerView.spin()
      MembershipDatastore.sharedInstance.query() {
        self.spinnerView.stop()
        self.refresh()
      }

      if let urlString = user["avatarUrl"] as? String,
         let avatarURL = NSURL(string: urlString + "?type=large") {
          avatarView.sd_setImageWithURL(avatarURL, placeholderImage: UIImage(named: "default-avatar"))
      }
      
    }
  }
  
  private func refresh() {
    self.tableView.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showGroup" {
      if let cell = sender as? GroupMembershipCell,
            vc = segue.destinationViewController as? GroupViewController {
        vc.userMember = cell.member
      }
    }
  }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GROUP_CELL", forIndexPath: indexPath) as! GroupMembershipCell
    let member = MembershipDatastore.sharedInstance.memberships[indexPath.row]
    cell.member = member
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MembershipDatastore.sharedInstance.memberships.count
  }
}