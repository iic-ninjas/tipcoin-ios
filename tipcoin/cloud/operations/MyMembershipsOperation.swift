//
//  MyMembershipsOperation.swift
//  tipcoin
//
//  Created by Wertheimer, Udi on 6/10/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

class myMembershipsOperations {
  func run(callback: PFIdResultBlock) {
    PFCloud.callFunctionInBackground("myMemberships", withParameters: nil, block: callback)
  }
}