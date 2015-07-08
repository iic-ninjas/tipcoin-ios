//
//  Spinner.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class Spinner: UIImageView {
  
  private let imageName = "spinner"
  private let fullSpinDuration: NSTimeInterval = 1.0
  private let thirdRotation = CGFloat(M_PI * 2.0 / 3.0)
  private var shouldSpin = false
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    image = UIImage(named: imageName)
    backgroundColor = UIColor.clearColor()
    spin()
  }
  
  func stop() {
    shouldSpin = false
    hidden = true
  }
  
  func spin() {
    if (shouldSpin) { return }
    shouldSpin = true
    hidden = false
    UIView.animateWithDuration(fullSpinDuration / 3, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
      self.transform = CGAffineTransformRotate(self.transform, self.thirdRotation)
      }, completion: { [weak self] _ in
        if self?.shouldSpin == true {
          self?.spin()
        }
      })
  }
  
}

extension UIView {

  func startSpinning(spin: Double = 0) {
    self.tag = 1
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
      let rotation = CGFloat(M_PI * spin * 2.0 / 3.0)
      self.transform = CGAffineTransformMakeRotation(rotation)
      }, completion: { _ in
        if self.tag > 0 {
          self.startSpinning(spin: (spin + 1) % 3 )
        }
    })
  }
  
  func stopSpinning() {
    self.tag = 0
    self.transform = CGAffineTransformIdentity
  }
}