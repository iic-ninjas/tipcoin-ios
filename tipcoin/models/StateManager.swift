//
//  StateManager.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/8/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class StateManager {
  
  static let sharedInstance = StateManager()
  
  let kCurrentGroupKey = "TipCoin_CURRENT_GROUP"
  
  var currentGroupId: String?
  
  init() {
    load()
  }
  
  private func load() {
    let defaults = NSUserDefaults.standardUserDefaults()
    currentGroupId = defaults.stringForKey(kCurrentGroupKey)
  }
  
  private func dump() -> Bool {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let value = currentGroupId {
      defaults.setValue(value, forKey: kCurrentGroupKey)
    }
    return defaults.synchronize()
  }
  
  func setCurrentGroup(group: Group) {
    self.currentGroupId = group.objectId
    dump()
  }
}