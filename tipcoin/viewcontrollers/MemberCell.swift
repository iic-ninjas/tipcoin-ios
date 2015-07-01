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
  func spot(member: Member)
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
  
  var member: Member? {
    didSet {
      if let member = member {
        if let avatarUrl = member.avatarUrl,
          url = NSURL(string: avatarUrl) {
            avatarView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default-avatar"))
        }
        nameLabel.text = member.displayName
        balanceLabel.text = member.displayBalance
        resetState()
      }
    }
  }
  
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
    animateToSpotState()
    state = .Spot
  }
  
  @IBAction func didClickSpot(sender: AnyObject) {
    if (state != .Spot) { return }
    animateToSpottedState()
    state = .Spotted
    self.delegate?.spot(self.member!)
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
    
    let targetColor = UIColor(red:0.215, green:0.752, blue:0.396, alpha:1).CGColor
    let animation = CABasicAnimation(keyPath: "borderColor")
    animation.fromValue = self.spotButton.layer.borderColor
    animation.toValue = targetColor
    animation.duration = duration
    spotButton.layer.borderColor = targetColor
    spotButton.layer.addAnimation(animation, forKey: "borderAnimation")
  }
  
  private func animateToSpotState(){
    balanceLabel.hidden = false
    balanceLabel.alpha = 1
    spotButton.hidden = false
    spotButton.alpha = 0
    
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 4, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.spotButton.alpha = 1
      self.balanceLabel.alpha = 0
      }, completion: { complete in
    })
  }
  private func animateToBalanceState(completion: (()->())? = nil){
    
    balanceLabel.hidden = false
    balanceLabel.alpha = 0
    spotButton.hidden = false
    spotButton.alpha = 1
    
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 4, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.spotButton.alpha = 0
      self.balanceLabel.alpha = 1
      }, completion: { complete in
        completion?()
    })
  }
  
  private func resetSpotButton() {
    self.spotButton.setImage(nil, forState: .Normal)
    self.spotButton.setTitle("Spot", forState: .Normal)
    self.spotButton.layer.setBorderUIColor(UIColor(red:0.29, green:0.564, blue:0.886, alpha:1))
  }
  
  func resetState() {
    if (state == .Balance) { return }
    animateToBalanceState() {
      self.resetSpotButton()
    }
    state = .Balance
  }
}