//
//  ChooseLocationViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/12/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON
import UIKit

class ChooseLocationViewController: UIViewController {
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var confirmationLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var verifyButton: DrizzleBorderButton!
  
  fileprivate let disposeBag = DisposeBag()
  fileprivate let backButton = UIBarButtonItem(title: "Back",
                                               style: .plain,
                                               target: self,
                                               action: #selector(backTapped))
  
  fileprivate let viewModel: ChooseLocationViewModelType
  
  init(viewModel: ChooseLocationViewModelType = ChooseLocationViewModel())
  {
    self.viewModel = viewModel
    
    super.init(nibName: "ChooseLocationViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Lifecycle
extension ChooseLocationViewController {
  override func viewDidLoad()
  {
    locationTextField.delegate = self
    
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.drizzleWhite,
      NSFontAttributeName: UIFont(name: "Quicksand-Regular", size: 20)!
    ]
    
    navigationItem.title = "Set Home Location"
    
    handleDisplayingBackButton()
    setBindings()
  }
}

// MARK: - IBActions
extension ChooseLocationViewController: UITextFieldDelegate {
  @objc func backTapped()
  {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func verifyLocationTapped()
  {
    viewModel.setNewHomeLocation()
    backTapped()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
    let address = locationTextField.text ?? ""
    textField.resignFirstResponder()
    viewModel.getLocationFrom(addressString: address)
    
    return true
  }
}

// MARK: - Helpers
fileprivate extension ChooseLocationViewController {
  func setBindings()
  {
    viewModel.homeLocation.asObservable()
      .map { location in location != nil }
      .bindTo(backButton.rx.isEnabled)
      .addDisposableTo(disposeBag)
    
    viewModel.apiLocation.asObservable()
      .map { location in location != nil }
      .bindNext({ locationExists in
        self.verifyButton.isEnabled = locationExists
        self.confirmationLabel.isHidden = !locationExists
      })
      .addDisposableTo(disposeBag)
    
    viewModel.apiLocation.asObservable()
      .map { location in location?.formattedAddress }
      .bindTo(addressLabel.rx.text)
      .addDisposableTo(disposeBag)
    
    viewModel.isLoading
      .subscribe(onNext: { isLoading in
        UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
      })
      .addDisposableTo(disposeBag)
  }
  
  func handleDisplayingBackButton()
  {
    if viewModel.homeLocation.value == nil {
      navigationItem.setHidesBackButton(true, animated: true)
      navigationController?.navigationBar.tintColor = UIColor.drizzleDarkGray
    }
    else {
      navigationItem.setHidesBackButton(false, animated: false)
      navigationController?.navigationBar.tintColor = UIColor.drizzleWhite
    }
  }
}
