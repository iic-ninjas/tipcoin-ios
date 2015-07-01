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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showMember" {
      if let cell = sender as? MemberCell,
        vc = segue.destinationViewController as? MemberViewController {
          cell.selected = false
          vc.member = members[cell.tag]
      }
      
    }
  }

  var group: Group? {
    didSet {
      let mineGroup = group
      if let group = group {
        self.navigationItem.title = group.name
        GetGroupInfo.get(group.objectId!) { group in
          self.members = group.members.sorted { left, right in
            if left.balance < right.balance { return true }
            if left.balance > right.balance { return false }
            return left.displayName < right.displayName
          }
        }
      }
    }
  }
  var members: [Member] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  @IBAction func backToGroup(segue: UIStoryboardSegue) {
  }

}

extension GroupViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MEMBER_CELL", forIndexPath: indexPath) as! MemberCell
    cell.tag = indexPath.row
    cell.setMember(members[indexPath.row])
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return members.count
  }
  
}