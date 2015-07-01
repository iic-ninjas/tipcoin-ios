//
//  MemberCell.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

protocol MemberCellDelegate {
  func cellStateChanged(cell: MemberCell)
}

class MemberCell: UITableViewCell {
  
  enum State {
    case Balance, Spot, Spotted
  }
  
  var state: State = .Balance {
    didSet {
      delegate?.cellStateChanged(self)
    }
  }
  
  var delegate: MemberCellDelegate?
  
  @IBOutlet weak var spotButton: UIButton!
  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var balanceLabel: UILabel! {
    didSet {
      let gesture = UITapGestureRecognizer(target: self, action: "didTapBalance:")
      balanceLabel.addGestureRecognizer(gesture)
    }
  }
  
  func didTapBalance(gesture: UITapGestureRecognizer){
    self.resetSpotButton()
    self.spotButton.hidden = false
    self.balanceLabel.hidden = true
    state = .Spot
  }
  
  @IBAction func didClickSpot(sender: AnyObject) {
    if (state != .Spot) { return }
    println("Spotted")
    animateToSpottedState()
    state = .Spotted
  }
  
  func setMember(member: Member) {
    if let avatarUrl = member.avatarUrl,
                 url = NSURL(string: avatarUrl) {
      avatarView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default-avatar"))

    }
    
    nameLabel.text = member.displayName
    balanceLabel.text = member.displayBalance
    resetState()
  }
  
  private func animateToSpottedState() {
    let duration = 0.5
    UIView.animateWithDuration(duration) {
      self.spotButton.setImage(UIImage(named: "checkmark")
        , forState: .Normal)
      self.spotButton.setTitle("", forState: .Normal)
      self.spotButton.setNeedsLayout()
      self.spotButton.layoutIfNeeded()
    }
    
    let animation = CABasicAnimation(keyPath: "borderColor")
    animation.fromValue = self.spotButton.layer.borderColor
    let targetColor = UIColor(red:0.215, green:0.752, blue:0.396, alpha:1).CGColor
    animation.toValue = targetColor
    animation.duration = duration
    self.spotButton.layer.borderColor = targetColor
    self.spotButton.layer.addAnimation(animation, forKey: "borderAnimation")
  }
  
  private func resetSpotButton() {
    self.spotButton.setImage(nil, forState: .Normal)
    self.spotButton.setTitle("Spot", forState: .Normal)
    self.spotButton.layer.setBorderUIColor(UIColor(red:0.29, green:0.564, blue:0.886, alpha:1))
  }
  
  func resetState() {
    if (state == .Balance) { return }
    spotButton.hidden = true
    resetSpotButton()
    balanceLabel.hidden = false
  }
}