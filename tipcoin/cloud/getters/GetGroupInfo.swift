//
//  GetGroupInfo.swift
//  tipcoin
//
//  Created by Wertheimer, Udi on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class GetGroupInfo {
  class func get(groupId: String, callback: (Group) -> ()) {
    PFCloud.callFunctionInBackground("groupInfo", withParameters: buildParams(groupId)) { rawResponse, error in
      if let error = error {
        println("error!")
        println(error.description)
      }
      
      if let group = rawResponse as? Group {
        callback(group)
      }
    }
  }
  
  class func buildParams(groupId: String) -> [String: String] {
    return ["group": groupId]
  }
}