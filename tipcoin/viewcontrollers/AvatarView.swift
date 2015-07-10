//
//  AvatarView.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/10/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

private let avatarLargeModifier = "?type=large"
private let defaultAvatarImage = UIImage(named: "default-avatar")

extension UIImageView {
  
  func setUser(user: PFUser, largeVariant: Bool = false){
    let avatarUrl = user["avatarUrl"] as? String
    setAvatarUrl(avatarUrl, largeVariant: largeVariant)
  }
  
  func setMember(member: Member?, largeVariant: Bool = false){
    let modifier = largeVariant ? avatarLargeModifier : ""
    self.sd_cancelCurrentImageLoad()
    if let member = member,
           avatarUrl = member.avatarUrl,
           url = NSURL(string: avatarUrl + modifier) {
        self.sd_setImageWithURL(url, placeholderImage: defaultAvatarImage)
    } else {
      self.image = defaultAvatarImage
    }
  }
  
  private func setAvatarUrl(avatarURL: String?, largeVariant: Bool = false) {
    let modifier = largeVariant ? avatarLargeModifier : ""
    if let avatarUrl = avatarURL,
                 url = NSURL(string: avatarUrl + modifier) {
        self.sd_setImageWithURL(url, placeholderImage: defaultAvatarImage)
    }
  }
  
}