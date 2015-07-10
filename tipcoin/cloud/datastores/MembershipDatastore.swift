//
//  MembershipDatastore.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class MembershipDatastore: NSObject {
  static let sharedInstance = MembershipDatastore()
  
  var memberships: [Member] = []
  var loaded = false
  
  
  
  func query( callback: (()->())? = nil) {
    loaded = false
    MyMembershipsOperation.run { (memberships) in
      self.memberships = memberships.sorted { l,r in
        return l.updatedAt!.compare(r.updatedAt!) == NSComparisonResult.OrderedDescending
      }
      self.loaded = true
      callback?()
    }
  }
  
  func deleteGroup(index: Int) {
    memberships.removeAtIndex(index)
  }
  
}