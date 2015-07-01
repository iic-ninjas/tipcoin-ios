//
//  GroupMembershipCell.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class GroupMembershipCell: UITableViewCell {
  
  @IBOutlet weak var groupName: UILabel!
  @IBOutlet weak var balance: UILabel!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let selectedBgView = UIView()
    selectedBgView.backgroundColor = UIColor.whiteColor()
    self.selectedBackgroundView = selectedBgView
//    groupName.highlightedTextColor = UIColor.purpleColor()
  }
  
}