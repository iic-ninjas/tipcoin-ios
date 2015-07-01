//
//  PFObject+Equality.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

extension PFObject: Hashable, Equatable {
  
  public override var hashValue: Int {
    return self.objectId!.hashValue
  }
  
}

public func ==(lhs: PFObject, rhs: PFObject) -> Bool {
  return lhs.objectId == rhs.objectId
}
