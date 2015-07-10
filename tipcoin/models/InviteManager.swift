//
//  InviteManager.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/8/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation
import SwiftyDrop


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
    JoinGroupOperation.run(groupID!, inviteToken: inviteToken!, callback: { group, err in
      if let group = group as? Group {
        self.clearInvite()
        Drop.down("You just joined group \"\(group.name)\"", blur: .Dark)
        NSNotificationCenter.defaultCenter().postNotificationName("JOINED_GROUP", object: group)
      } else if err != nil {
        let errorMessage = err?.localizedDescription ?? "Error joining group"
        Drop.down(errorMessage, state: .Error)
      }
      callback(group, err)
    })
  }
  
}