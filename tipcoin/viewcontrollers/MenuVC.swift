//
//  MenuVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class MenuViewController: UIViewController {

  @IBOutlet weak var closeButton: UIButton! {
    didSet {
      closeButton.hidden = currentGroupMember == nil
    }
  }
  @IBOutlet weak var spinnerView: Spinner!
  @IBOutlet weak var tableView: UITableView! {
    didSet{
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 60
    }
  }
  @IBOutlet weak var avatarView: UIImageView!
  
  var currentGroupMember: Member?
  
  @IBAction func logOut(sender: AnyObject) {
    PFUser.logOut()
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
    println("+ MenuVC")
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "joinedGroup:", name: "JOINED_GROUP", object: nil)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  deinit{
    println("- MenuVC")
  }

  func joinedGroup(notification: NSNotification) {
    forceRefresh()
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
    if segue.identifier == "chooseGroup" || segue.identifier == "back" {
      if let member = sender as? Member,
            vc = segue.destinationViewController as? GroupViewController {
        StateManager.sharedInstance.setCurrentGroup(member.group)
        currentGroupMember = member
        vc.userMember = member
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
      cell.member = memberForIndexPath(indexPath)
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
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 1 || groupCount() == 0 { return }
    
    if currentGroupMember != nil {
      performSegueWithIdentifier("back", sender: memberForIndexPath(indexPath))
    } else {
      performSegueWithIdentifier("chooseGroup", sender: memberForIndexPath(indexPath))
    }
    
  }

  func groupCount() -> Int {
    return MembershipDatastore.sharedInstance.memberships.count
  }
  
  func memberForIndexPath(indexPath: NSIndexPath) -> Member {
    return MembershipDatastore.sharedInstance.memberships[indexPath.row]
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
//    return indexPath.section == 0 && groupCount() > 0
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      let alert = UIAlertController(title: "Delete Group", message: "Are you sure you want to delete this group? This action can not be undone", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { _ in
        MembershipDatastore.sharedInstance.deleteGroup(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
      }))
      alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { _ in
        tableView.setEditing(false, animated: true)
      }))
      self.presentViewController(alert, animated: true, completion: nil)

    }
  }

}
