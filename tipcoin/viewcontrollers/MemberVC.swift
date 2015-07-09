//
//  MemberVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class MemberViewController: UIViewController {
  
  @IBOutlet private weak var balanceLabel: UILabel!
  @IBOutlet weak var tippyView: UIImageView! {
    didSet {
      tippyView?.startSpinning()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let basicPart = "\(member!.firstName!)'s Balance: "
    let balancePart = member!.displayBalance
    let fullString = basicPart + balancePart
    let range = fullString.rangeOfString(balancePart, options: nil, range: nil, locale: nil)
    let attributedText = NSMutableAttributedString(string: fullString)
//    UIFont(name: "Helvetica-Neueu-Medium", size: balanceLabel.font.)
//    attributedText.addAttribute(NSFontAttributeName, value: <#AnyObject#>, range: <#NSRange#>)
//    balanceLabel.attributedText.attributesAtIndex(balance, effectiveRange: <#NSRangePointer#>)
    balanceLabel.attributedText = attributedText
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