//
//  HomeViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  fileprivate let viewModel: HomeViewModelType
  
  init(viewModel: HomeViewModelType = HomeViewModel())
  {
    self.viewModel = viewModel
    
    super.init(nibName: "HomeViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
  }
}

// Helpers
extension HomeViewController {
  func checkHomeLocation()
  {
    
  }
}
