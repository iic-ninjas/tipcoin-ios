//
//  InviteManager.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/8/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class InviteManager {
  
  static let sharedInstance = InviteManager()
  
  private(set) var groupID: String?
  private(set) var inviteToken: String?
  
  func receivedInviteWithGroupId(groupID: String?, inviteToken: String?) {
    self.groupID = groupID
    self.inviteToken = inviteToken
  }
  
  func hasInvite() -> Bool {
    return groupID != nil && inviteToken != nil
  }
  
  func clearInvite() {
    self.groupID = nil
    self.inviteToken = nil
  }
  
  func joinGroup(callback: PFIdResultBlock) {
    JoinGroupOperation.run(groupID!, inviteToken: inviteToken!, callback: { obj,err in
      if err == nil {
        self.clearInvite()
      }
      callback(obj, err)
    })
  }
  
}