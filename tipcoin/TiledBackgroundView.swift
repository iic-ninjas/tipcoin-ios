//
//  TiledBackgroundView.swift
//  tipcoin
//
//  Created by Bergman, Yon on 6/24/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

class TiledBackgroundView: UIView {
  
  private let patternView: UIView
  private var shouldStopAnimating: Bool = false
  
  required init(coder aDecoder: NSCoder) {
    patternView = UIView()
    super.init(coder: aDecoder)
    patternView.frame = self.frame.rectByInsetting(dx: -50, dy: 0).rectByOffsetting(dx: 0, dy: 0)
    insertSubview(patternView, atIndex: 0)
  }
  
  @IBInspectable var patternImage: UIImage? {
    didSet {
      if let patternImage = patternImage {
        patternView.backgroundColor = UIColor(patternImage: patternImage)
      }
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    patternView.frame = self.frame.rectByInsetting(dx: -50, dy: -30).rectByOffsetting(dx: 0, dy: 0)
  }
  
  func animate() {
    self.patternView.frame = self.patternView.frame.rectByOffsetting(dx: -10, dy: 0)
    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
      self.patternView.frame = self.patternView.frame.rectByOffsetting(dx: 10, dy: 0)
    }, completion: { finished in
      if self.shouldStopAnimating {
        self.shouldStopAnimating = false
      } else {
        self.animate()
      }
    })
  }
  
  func stopAnimation() {
    shouldStopAnimating = true
  }
  
}