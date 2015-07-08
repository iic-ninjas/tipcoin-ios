//
//  Member.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class Member: PFObject, PFSubclassing {
  override class func initialize() {
    var onceToken: dispatch_once_t = 0;
    dispatch_once(&onceToken) {
      self.registerSubclass()
    }
  }

  class func parseClassName() -> String {
    return "Member"
  }

  @NSManaged var firstName: String?
  @NSManaged var lastName: String?
  @NSManaged var displayName: String?
  @NSManaged var avatarUrl: String?
  @NSManaged var balance: Int
  
  @NSManaged var user: PFUser?
  @NSManaged var group: Group
  @NSManaged var transactions: [Transaction]
  
  var sortedTransactions: [Transaction] {
    return transactions.sorted { left, right in
      if let lCreatedAt = left.createdAt, rCreatedAt = right.createdAt {
        return lCreatedAt.compare(rCreatedAt) == NSComparisonResult.OrderedDescending
      } else {
        return false
      }
    }
  }


  
  var displayBalance: String {
    if balance == 0 { return "0" }
    else if balance < 0 { return balance.description }
    else {
      return "+" + balance.description
    }
  }
}
