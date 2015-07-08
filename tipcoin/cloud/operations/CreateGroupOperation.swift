//
//  CreateGroupOperation.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/8/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class CreateGroupOperation {
  class func run(name: String, callback: PFIdResultBlock){
    var params:[String:String] = [
      "name": name,
    ]
    PFCloud.callFunctionInBackground("createGroup", withParameters: params) { group, err in
      callback(group, err)
    }
  }
}