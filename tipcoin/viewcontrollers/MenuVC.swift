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
  @IBOutlet weak var tableView: UITableView! {
    didSet{
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 60
    }
  }
  @IBOutlet weak var avatarView: UIImageView!

  @IBAction func logOut(sender: AnyObject) {
    PFUser.logOut()
    performSegueWithIdentifier("back", sender: nil)
  }

  @IBAction func closeMenu(sender: AnyObject) {

  }

  @IBAction func backToMenu(segue: UIStoryboardSegue) {
    forceRefresh()
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    if let user = PFUser.currentUser() {
      self.forceRefresh()
      avatarView.setUser(user, largeVariant: true)
    }
  }

  private func forceRefresh() {
    self.spinnerView.spin()
    MembershipDatastore.sharedInstance.query() {
      self.refreshed()
    }
  }

  private func refreshed() {
    self.tableView.reloadData()
    self.spinnerView.stop()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showGroup" {
      if let cell = sender as? GroupMembershipCell,
            vc = segue.destinationViewController as? GroupViewController {
        if let group = cell.member?.group {
          StateManager.sharedInstance.setCurrentGroup(group)
        }
        vc.userMember = cell.member
      }
    }
  }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 1 {
      return tableView.dequeueReusableCellWithIdentifier("NEW_GROUP_CELL", forIndexPath: indexPath) as! UITableViewCell
    } else if groupCount() == 0 {
      return tableView.dequeueReusableCellWithIdentifier("EMPTY_CELL", forIndexPath: indexPath) as! UITableViewCell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("GROUP_CELL", forIndexPath: indexPath) as! GroupMembershipCell
      let member = MembershipDatastore.sharedInstance.memberships[indexPath.row % groupCount()]
      cell.member = member
      return cell
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 { return 1 }
    if !MembershipDatastore.sharedInstance.loaded {
      return 0
    } else {
      return max(groupCount(), 1)
    }
  }

  func groupCount() -> Int {
    return MembershipDatastore.sharedInstance.memberships.count
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

}
