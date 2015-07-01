//
//  CALayer+border.swift
//  tipcoin
//
//  Created by Bergman, Yon on 7/1/15.
//  Copyright (c) 2015 CPC Ninjas. All rights reserved.
//

import Foundation

extension CALayer {
  
  func setBorderUIColor(color: UIColor!){
    if let color = color {
      self.borderColor = color.CGColor
    }
  }
  
  func borderUIColor() -> UIColor! {
    return UIColor(CGColor: self.borderColor)
  }
  
}