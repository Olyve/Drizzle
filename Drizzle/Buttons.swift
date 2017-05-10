//
//  Buttons.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/12/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class DrizzleBorderButton: UIButton {
  let disposeBag = DisposeBag()
  
  deinit {
    removeObserver(self, forKeyPath: #keyPath(isEnabled))
  }
  
  override func awakeFromNib() {
    layer.cornerRadius = 5
    layer.borderWidth = 2
    titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
    setButtonColors()
    
    addObserver(self, forKeyPath: #keyPath(isEnabled), options: [.old, .new], context: nil)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
  {
    if keyPath == #keyPath(isEnabled) {
      self.setButtonColors()
    }
  }
  
  func setButtonColors()
  {
    let color = self.isEnabled == true ? UIColor.drizzleGreen : UIColor.lightGray
    layer.borderColor = color.cgColor
  }
}
