//
//  MyMembershipsOperation.swift
//  tipcoin
//
//  Created by Wertheimer, Udi on 6/10/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

class MyMembershipsOperation {
  class func run(callback: ([Member]) -> ()) {
    PFCloud.callFunctionInBackground("myMemberships", withParameters: nil) { data, err in
      if let memberships = data as? [Member] {
        callback(memberships)
      } else {
        println("Error \(err)")
      }
    }
  }
}