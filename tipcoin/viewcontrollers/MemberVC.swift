//
//  MemberVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class MemberViewController: UIViewController {
  
  @IBOutlet weak var tippyView: UIImageView! {
    didSet {
      tippyView?.startSpinning()
    }
  }
  
  var refreshControl: UIRefreshControl!

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
      tableView.addSubview(refreshControl)
    }
  }

  var member: Member? {
    didSet {
      navigationItem.title = member?.displayName
      refresh()
    }
  }
  
  var transactions: [Transaction] = [] {
    didSet {
      refreshControl.endRefreshing()
      tableView.reloadData()
      tippyView.stopSpinning()
    }
  }
  
  func refresh() {
    tippyView?.startSpinning()
    if let member = member {
      MemberInfoOperation.run(member, callback: { (newMember, err) -> Void in
        if let newMember = newMember as? Member {
          self.transactions = newMember.sortedTransactions ?? []
        }
      })
    }
  }

}


extension MemberViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TRANSACTION_CELL", forIndexPath: indexPath) as! TransactionCell
    let transaction = transactions[indexPath.row]
    cell.setTransaction(transaction, member: member!)
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return transactions.count
  }
  
}