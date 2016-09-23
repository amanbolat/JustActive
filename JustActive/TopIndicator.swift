//
//  AmanWhisper.swift
//  ActivityIndicator
//
//  Created by AMANBOLAT BALABEKOV on 16.09.16.
//  Copyright © 2016 AMANBOLAT BALABEKOV. All rights reserved.
//

import Foundation
import UIKit

//open class TopIndicatorFactory: NSObject {
//  var indicators: [TopIndicatorFactory] = []
//
//  override init() {
//    super.init()
//    NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
//  }
//
//
//
//  deinit {
//    NotificationCenter.default.removeObserver(self)
//  }
//
//  func orientationDidChange() {
//    indicator?.deviceOrientationDidChange()
//  }
//}

open class TopIndicator: UIView {
  
  public enum PresentationType {
    case show
    case present
  }
  
  static var showTimer = Timer()
  var presentTimer = Timer()
  
  struct Configuration {
    static let height: CGFloat = 24
    static let textColor: UIColor = UIColor.white
    static let backgroundColor: UIColor = UIColor.brown
  }
  
  lazy var label: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "HelveticaNeue", size: 13)
    label.textAlignment = .center
    label.frame.size.width = UIScreen.main.bounds.width - 60
    
    return label
  }()
  
  weak var navigationController: UINavigationController?
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("aDecoder init not implemented")
  }
  
  public init(navigationController: UINavigationController) {
    super.init(frame: CGRect.zero)
    
    NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
    
    self.navigationController = navigationController
    
    //    backgroundColor = UIColor.black
    clipsToBounds = true
    alpha = 0
    frame = CGRect(
      x: 0,
      y: navigationController.navigationBar.frame.height,
      width: UIScreen.main.bounds.width,
      height: Configuration.height)
    
    addSubview(label)
    
    //    label.text = text
    //    label.textColor = textColor
    //    label.sizeToFit()
    
    NSLayoutConstraint.useAndActivateConstraints(constraints: [
      label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ])
  }
}

extension TopIndicator {
  open func craft(text: String, textColor: UIColor, bgColor: UIColor, type: PresentationType) {
    guard let nc = self.navigationController else { return }
    TopIndicator.showTimer.invalidate()
    
    var navBarContainsView = false
    
    nc.navigationBar.subviews.forEach {
      switch $0 {
      case is TopIndicator:
        navBarContainsView = true
        $0.removeFromSuperview()
        break
      default:
        return
      }
    }
    
    self.navigationController?.navigationBar.addSubview(self)
    setup(text: text, textColor: textColor, bgColor: bgColor)
    
    switch type {
    case .present:
      present()
    case .show:
      show()
    }
  }
  
  func present() {
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 1
    })
  }
  
  func show() {
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 1
    }) { _ in
      TopIndicator.showTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.showTimerFired(_:)), userInfo: nil, repeats: false)
    }
  }
  
  func setup(text: String, textColor: UIColor, bgColor: UIColor) {
    self.label.text = text
    self.label.textColor = textColor
    self.label.textAlignment = .center
    self.label.sizeToFit()
    self.backgroundColor = bgColor
  }
  
  func showTimerFired(_ timer: Timer) {
    hide()
  }
  
  open func hide(withAnimation duration: TimeInterval = 0.3) {
    
    TopIndicator.showTimer.invalidate()
    print("Hide indicator")
    UIView.animate(withDuration: duration, animations: {
      self.alpha = 0
    }) { _ in
      self.removeFromSuperview()
    }
  }
  
  open func change(withText text: String, textColor: UIColor, bgColor: UIColor) {
    setup(text: text, textColor: textColor, bgColor: bgColor)
  }
  
  open func deviceOrientationDidChange() {
    guard let nc = navigationController else { return }
    frame = CGRect(
      x: 0,
      y: nc.navigationBar.frame.height,
      width: UIScreen.main.bounds.width,
      height: Configuration.height)
  }
}



