//
//  SpotOperation.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation
import SwiftyDrop


class SpotOperation {
  class func run(from: Member, to: Member, callback: PFIdResultBlock){
    var params:[String:String] = [
      "from": from.objectId!,
      "to": to.objectId!,
    ]
    PFCloud.callFunctionInBackground("spot", withParameters: params) { transaction, err in
      if (err != nil) {
        from.balance += 1
        to.balance -= 1
      }
      if let transaction = transaction as? Transaction,
        firstName = to.firstName {
          Drop.down("You spotted \"\(firstName)\"", blur: .Dark)
      } else {
        let message = err?.localizedDescription ?? "Error while spotting"
        Drop.down(message, state: .Error)
      }

      callback(transaction, err)
    }
  }
}