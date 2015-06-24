//
//  GetGroupInfo.swift
//  tipcoin
//
//  Created by Wertheimer, Udi on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class GetGroupInfo {
  func get(group: Group, callback: Group -> ()) {
    PFCloud.callFunctionInBackground("groupInfo", withParameters: buildParams(group)) { rawResponse, error in
      if let group = rawResponse as? Group {
        callback(group)
      }
    }
  }
  
  func buildParams(group: Group) -> [String: String] {
    if let objectId = group.objectId {
      return ["group": group.objectId!]
    } else {
      return [:]
    }
  }
}