//
//  AmanWhisper.swift
//  ActivityIndicator
//
//  Created by AMANBOLAT BALABEKOV on 16.09.16.
//  Copyright © 2016 AMANBOLAT BALABEKOV. All rights reserved.
//

import Foundation
import UIKit

class TopIndicatorFactory: NSObject {
  var messager: TopIndicator?
  
  override init() {
    super.init()
    NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
  }
  
  convenience init(messager: TopIndicator) {
    self.init()
    self.messager = messager
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func orientationDidChange() {
    messager?.deviceOrientationDidChange()
  }
}




struct TopIndicator {
  var mainView: UIView
//  var delegate: UIView
  
  struct Configuration {
    static let height: CGFloat = 24
    static let messageColor: UIColor = UIColor.white
    static let messageBgColor: UIColor = UIColor.brown
  }
  
  lazy var label: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "HelveticaNeue", size: 13)
    label.textAlignment = .center
    label.frame.size.width = UIScreen.main.bounds.width - 60
    
    return label
  }()
  
  weak var navigationController: UINavigationController?
  
  init(navigationController: UINavigationController, message: String, messageColor: UIColor = Configuration.messageColor, messageBgColor: UIColor = Configuration.messageBgColor) {
    self.navigationController = navigationController
    
    mainView = UIView()
    mainView.backgroundColor = messageBgColor
    mainView.clipsToBounds = true
    mainView.frame = CGRect(
      x: 0,
      y: navigationController.navigationBar.frame.height,
      width: UIScreen.main.bounds.width,
      height: Configuration.height)

    mainView.addSubview(label)
    
    label.text = message
    label.textColor = messageColor
    label.sizeToFit()
 
    label.translatesAutoresizingMaskIntoConstraints = false
    label.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true

  }
  
  func show() {
    self.navigationController?.navigationBar.addSubview(mainView)
    UIView.animate(withDuration: 0.5) {
      self.mainView.isHidden = false
    }
  }
  
  func hide() {
    UIView.animate(withDuration: 0.5, animations: { 
      self.mainView.isHidden = true
      }) { _ in
        self.mainView.removeFromSuperview()
    }
  }
  
  func deviceOrientationDidChange() {
    guard let nc = navigationController else { return }
    mainView.frame = CGRect(
      x: 0,
      y: nc.navigationBar.frame.height,
      width: UIScreen.main.bounds.width,
      height: Configuration.height)
  }
}


