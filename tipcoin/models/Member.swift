//
//  Member.swift
//  tipcoin
//
//  Created by Wertheimer, Udi on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class Member: PFObject, PFSubclassing {
  override class func initialize() {
    var onceToken: dispatch_once_t = 0
    dispatch_once(&onceToken) {
      self.registerSubclass()
    }
  }
  
  class func parseClassName() -> String {
    return "Member"
  }
  
  @NSManaged var displayName: String
  @NSManaged var balance: Int
  @NSManaged var avatarUrl: String
}