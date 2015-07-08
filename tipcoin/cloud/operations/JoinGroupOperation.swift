//
//  JoinGroupOperation.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/8/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class JoinGroupOperation {
  class func run(groupID: String, inviteToken: String, callback: PFIdResultBlock){
    var params:[String:String] = [
      "group": groupID,
      "inviteToken": inviteToken
    ]
    PFCloud.callFunctionInBackground("joinGroup", withParameters: params) { group, err in
      callback(group, err)
    }
  }

}