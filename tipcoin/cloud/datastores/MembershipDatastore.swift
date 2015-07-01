//
//  MembershipDatastore.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class MembershipDatastore: NSObject {
  static let sharedInstance = MembershipDatastore()
  
  var memberships: [Member] = []
  var loaded = false
  
  
  
  func query( callback: (()->())? = nil) {
    loaded = false
    MyMembershipsOperations.run { (memberships) in
      self.memberships = memberships
      self.loaded = true
      callback?()
    }
  }
  
}

//
////
////  PeopleStore.swift
////  mokojin
////
////  Created by Yonatan Bergman on 3/22/15.
////  Copyright (c) 2015 iicninjas. All rights reserved.
////
//
//import Foundation
//
//private let _PeopleStoreInstance = PeopleStore()
//
//let PeopleStoreNotificationName = "PeopleStoreUpdated"
//class PeopleStore {
//  
//  class var sharedInstance: PeopleStore {
//    return _PeopleStoreInstance
//  }
//  
//  let getter:GetPeople
//  var people:People = []
//  var loaded = false
//  
//  internal init(getter:GetPeople = GetPeople()){
//    self.getter = getter
//    query()
//  }
//  
//  func forceUpdate() -> PeopleStore {
//    query()
//    return self
//  }
//  
//  private func query(){
//    loaded = false
//    getter.get {
//      self.loaded = true
//      self.people = $0
//      NSNotificationCenter.defaultCenter().postNotificationName(PeopleStoreNotificationName,
//        object: self.people)
//    }
//    
//  }
//  
//}