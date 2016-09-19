//
//  AmanIndicator.swift
//  ActivityIndicator
//
//  Created by AMANBOLAT BALABEKOV on 15.09.16.
//  Copyright © 2016 AMANBOLAT BALABEKOV. All rights reserved.
//

import Foundation
import UIKit

struct SimpleIndicator {
  var messageView: UIView
  var indicator: UIActivityIndicatorView
  var label: UILabel
  var stack: UIStackView
  weak var vc: UIViewController?
  
  init(vc: UIViewController, message: String) {
    self.vc = vc
    
    messageView = UIView()
    messageView.translatesAutoresizingMaskIntoConstraints = false

    messageView.layer.backgroundColor = UIColor.darkGray.cgColor
    messageView.alpha = 0.9
    messageView.layer.cornerRadius = 10
    
    indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    indicator.color = UIColor.white
    
    label = UILabel()
    label.font = UIFont(name: "HelveticaNeue", size: 15)
    label.text = message
    label.textAlignment = .center
    label.textColor = UIColor.white
    label.sizeToFit()
    
    stack = UIStackView()//(frame: messageView.bounds)
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 5
    stack.addArrangedSubview(indicator)
    stack.addArrangedSubview(label)
    
    messageView.addSubview(stack)
    
    let alignXConstraint = NSLayoutConstraint(item: stack, attribute: .centerX, relatedBy: .equal, toItem: messageView, attribute: .centerX, multiplier: 1, constant: 0)
    let alignYConstraint = NSLayoutConstraint(item: stack, attribute: .centerY, relatedBy: .equal, toItem: messageView, attribute: .centerY, multiplier: 1, constant: 0)
    
    NSLayoutConstraint.useAndActivateConstraints(constraints: [alignXConstraint, alignYConstraint])
    
//    stack.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true
//    stack.centerYAnchor.constraint(equalTo: messageView.centerYAnchor).isActive = true
  }
  
  func show() {
    messageView.alpha = 0.5
    if let vc = vc {
      vc.view.addSubview(messageView)
      
      messageView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
      messageView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
      messageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
      messageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
      
      indicator.startAnimating()
      messageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      UIView.animate(withDuration: 0.3, animations: {
        self.messageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.messageView.alpha = 1
        }, completion: nil)
    }
  }
  
  func hide() {
    UIView.animate(withDuration: 0.3, animations: { 
      self.messageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      self.messageView.alpha = 0
      }) { (completed) in
        self.messageView.transform = CGAffineTransform.identity
        self.messageView.removeFromSuperview()
    }
  }
}

extension NSLayoutConstraint {
  
  public class func useAndActivateConstraints(constraints: [NSLayoutConstraint]) {
    for constraint in constraints {
      if let view = constraint.firstItem as? UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
      }
    }
    activate(constraints)
  }
}
