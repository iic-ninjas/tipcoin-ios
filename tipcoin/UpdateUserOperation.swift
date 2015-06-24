//
//  UpdateUserOperation.swift
//  tipcoin
//
//  Created by Bergman, Yon on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

struct UserInfo {
  var firstName: String
  var lastName: String
  var displayName: String
  var avatarUrl: String
}

class UpdateUserOperation {
  func run(userInfo: UserInfo, callback: PFIdResultBlock){
    var params:[String:String] = [
      "firstName": userInfo.firstName,
      "lastName": userInfo.lastName,
      "displayName": userInfo.displayName,
      "avatarUrl": userInfo.avatarUrl,
    ]
    PFCloud.callFunctionInBackground("updateUser", withParameters: params, block: callback)
  }
}