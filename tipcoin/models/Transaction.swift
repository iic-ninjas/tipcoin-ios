//
//  Transaction.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class Transaction : PFObject, PFSubclassing {
  override class func initialize() {
    var onceToken : dispatch_once_t = 0;
    dispatch_once(&onceToken) {
      self.registerSubclass()
    }
  }
  
  class func parseClassName() -> String {
    return "Transaction"
  }
  
  @NSManaged var from: Member
  @NSManaged var to: Member
  
}