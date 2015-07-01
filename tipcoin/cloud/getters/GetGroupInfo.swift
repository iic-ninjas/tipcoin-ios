//
//  GetGroupInfo.swift
//  tipcoin
//
//  Created by Wertheimer, Udi on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class GetGroupInfo {
  class func get(groupId: String, callback: Group -> ()) {
    PFCloud.callFunctionInBackground("groupInfo", withParameters: buildParams(groupId)) { rawResponse, error in
      if let error = error {
        println("error!")
        println(error.description)
      }
      
      if let group = rawResponse as? PFObject {
        println(group.objectId)
        println(group["members"])
      } else if let string = rawResponse as? String {
        println("operation string")
      } else {
        println("operation failed")
      }
    }
  }
  
  class func buildParams(groupId: String) -> [String: String] {
    return ["group": groupId]
  }
}