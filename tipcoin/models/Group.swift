//
//  Group.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class Group: PFObject, PFSubclassing {
  override class func initialize() {
    var onceToken: dispatch_once_t = 0;
    dispatch_once(&onceToken) {
      self.registerSubclass()
    }
  }

  class func parseClassName() -> String {
    return "Group"
  }

  @NSManaged var name: String
  @NSManaged var inviteToken: String
  @NSManaged var members: [Member]
  
  var sortedMembers: [Member] {
    return members.sorted { left, right in
      if left.balance < right.balance { return true }
      if left.balance > right.balance { return false }
      return left.displayName < right.displayName
      }.filter { member in
        return member.user != PFUser.currentUser()
    }
  }
  
  var inviteUrl: NSURL? {
    let string = "http://tipcoin.parseapp.com/invite?gid=\(objectId!)&iid=\(inviteToken)"
    return NSURL(string: string)
  }
  
}
