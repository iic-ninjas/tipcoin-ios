//
//  TransactionCell.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/8/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class TransactionCell: UITableViewCell {
  
  enum State {
    case Date, Time
    func flip() -> State {
      switch self {
        case Date: return .Time
        case Time: return .Date
      }
    }
  }
  
  var state: State = .Date
  
  enum TransactionDirection {
    case From, To
    
    var image: UIImage? {
      switch self {
        case .From: return UIImage(named: "positive")
        case .To: return UIImage(named: "negative")
      }
    }
  }
  
  @IBOutlet weak var dateLabel: UILabel! {
    didSet {
      let gesture = UITapGestureRecognizer(target: self, action: "didTapDate:")
      dateLabel?.addGestureRecognizer(gesture)
    }
  }
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var indicatorImage: UIImageView!
  
  var transaction: Transaction? {
    didSet {
      if let transaction = transaction {
        self.state = .Date
        updateDateTimeLabel()
        nameLabel.text = name
        indicatorImage.image = direction.image
      }
    }
  }
  var member: Member?
  
  func setTransaction(transaction: Transaction, member: Member) {
    self.member = member
    self.transaction = transaction
  }
  
  private var direction: TransactionDirection {
    if transaction?.from == member {
      return .From
    } else {
      return .To
    }
  }
  
  private var name: String? {
    switch direction {
      case .From: return transaction?.to.displayName
      case .To: return transaction?.from.displayName
    }
  }
  
  func didTapDate(gesture: UITapGestureRecognizer){
    if gesture.state == UIGestureRecognizerState.Ended {
      self.state = self.state.flip()
      updateDateTimeLabel()
    }
  }
  
  func updateDateTimeLabel() {
    if let transaction = transaction {
      dateLabel.text = state == .Date ? transaction.displayDate : transaction.displayTime
    }
  }

}