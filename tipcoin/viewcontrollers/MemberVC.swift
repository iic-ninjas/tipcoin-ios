//
//  MemberVC.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation
import SwiftyDrop

class MemberViewController: UIViewController {
  
  @IBOutlet weak var spotButton: UIButton!
  
  @IBOutlet weak var avatarView: UIImageView! {
    didSet {
      avatarView.setMember(member)
    }
  }
  
  @IBOutlet private weak var balanceLabel: UILabel!
  @IBOutlet weak var tippyView: UIImageView! {
    didSet {
      tippyView?.startSpinning()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let basicPart = isMe ? "Your Personal Balance: " : "\(member!.firstName!)'s Balance: "
    let balancePart = member!.displayBalance
    let fullString = basicPart + balancePart
    let range = fullString.rangeOfString(balancePart, options: nil, range: nil, locale: nil)
    let attributedText = NSMutableAttributedString(string: fullString)
//    UIFont(name: "Helvetica-Neueu-Medium", size: balanceLabel.font.)
//    attributedText.addAttribute(NSFontAttributeName, value: <#AnyObject#>, range: <#NSRange#>)
//    balanceLabel.attributedText.attributesAtIndex(balance, effectiveRange: <#NSRangePointer#>)
    balanceLabel.attributedText = attributedText
    
    if isMe {
      self.spotButton.removeFromSuperview()
    }
  }
  
  var isMe: Bool { return PFUser.currentUser() != nil && member?.user == PFUser.currentUser() }
  
  var refreshControl: UIRefreshControl!

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
      tableView.addSubview(refreshControl)
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 50

    }
  }
  
  var userMember: Member?

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
  
  var fetchedTransaction = false
  
  func refresh() {
    tippyView?.startSpinning()
    if let member = member {
      MemberInfoOperation.run(member, callback: { (newMember, err) -> Void in
        if let newMember = newMember as? Member {
          self.fetchedTransaction = true
          self.transactions = newMember.sortedTransactions ?? []
        }
      })
    }
  }
  
  @IBAction func didSpot(sender: AnyObject) {
    if let from = userMember, to = member {
      self.spotButton.enabled = false
      animateToSpottedState()
      SpotOperation.run(from, to: to) { transaction, err in
        self.refresh()
      }
    }
  }
  
  private func animateToSpottedState() {
    let duration = 0.5
    UIView.animateWithDuration(duration) {
      self.spotButton.setImage(UIImage(named: "checkmark-white")
        , forState: .Normal)
      self.spotButton.setTitle("", forState: .Normal)
      self.spotButton.setNeedsLayout()
      self.spotButton.layoutIfNeeded()
    }
  }

}


extension MemberViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if transactions.count == 0 {
      return tableView.dequeueReusableCellWithIdentifier("EMPTY_CELL", forIndexPath: indexPath) as! UITableViewCell
    }
    let cell = tableView.dequeueReusableCellWithIdentifier("TRANSACTION_CELL", forIndexPath: indexPath) as! TransactionCell
    let transaction = transactions[indexPath.row]
    cell.setTransaction(transaction, member: member!)
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !fetchedTransaction { return 0 }
    return max(transactions.count, 1)
  }
  
}