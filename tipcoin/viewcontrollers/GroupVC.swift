//
//  GroupVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class GroupViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
      tableView.addSubview(refreshControl)
    }
  }
  var refreshControl: UIRefreshControl!
  var currentSelectedCell: MemberCell?
  
    
  @IBAction func shareInvite(sender: AnyObject) {
    println(group)
    println(group?.inviteUrl)
    if let url = group?.inviteUrl {
      println(url)
      let sharingItems = [url, url.absoluteString!]
      let shareVC = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
      shareVC.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact]
      presentViewController(shareVC, animated: true, completion: nil)
    }
    
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

  var userMember: Member? {
    didSet {
      self.group = userMember?.group
    }
  }
  
  var group: Group? {
    didSet {
      let mineGroup = group
      if let group = group {
        self.navigationItem.title = group.name
        self.refresh()
      }
    }
  }
  
  var members: [Member] = [] {
    didSet {
      tableView.reloadData()
      refreshControl.endRefreshing()
    }
  }
  
  func refresh() {
    if let group = group {
      GetGroupInfo.get(group.objectId!) { group in
        self.members = group.sortedMembers
      }
    }
  }
  
  func refreshUI() {
    self.tableView.reloadData()
  }
  
  @IBAction func backToGroup(segue: UIStoryboardSegue) {
  }

}



extension GroupViewController: UITableViewDataSource, UITableViewDelegate, MemberCellDelegate {
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MEMBER_CELL", forIndexPath: indexPath) as! MemberCell
    cell.tag = indexPath.row
    cell.member = members[indexPath.row]
    cell.delegate = self
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return members.count
  }
  
  func cellStateChanged(cell: MemberCell) {
    if cell.state == .Spot {
      self.currentSelectedCell?.resetState()
      self.currentSelectedCell = cell
    }
  }
  
  func spot(member: Member) {
    SpotOperation.run(self.userMember!, to: member) { transaction, err in
      println(transaction)
      self.refreshUI()
    }
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    if let cell = self.currentSelectedCell {
      if cell.state != .Spot {
        cell.resetState()
      }
    }
  }
  
}

