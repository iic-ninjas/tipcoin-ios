//
//  MemberInfoOperation.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/8/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class MemberInfoOperation {
  class func run(member: Member, callback: PFIdResultBlock){
    var params:[String:String] = [
      "member": member.objectId!,
    ]
    PFCloud.callFunctionInBackground("memberInfo", withParameters: params) { member, err in
      callback(member, err)
    }
  }
  
}