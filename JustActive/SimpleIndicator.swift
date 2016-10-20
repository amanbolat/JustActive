//
//  AmanIndicator.swift
//  ActivityIndicator
//
//  Created by AMANBOLAT BALABEKOV on 15.09.16.
//  Copyright © 2016 AMANBOLAT BALABEKOV. All rights reserved.
//

import Foundation
import UIKit

public class SimpleIndicator {
  
  static var messageView: UIView = {
    
    var messageView = UIView()
    messageView.tag = 99
    messageView.translatesAutoresizingMaskIntoConstraints = false

    messageView.layer.backgroundColor = UIColor.darkGray.cgColor
    messageView.alpha = 0.9
    messageView.layer.cornerRadius = 10
    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    indicator.color = UIColor.white
    indicator.tag = 33
    
    var label = UILabel()
    label.font = UIFont(name: "HelveticaNeue", size: 15)
    label.text = ""
    label.textAlignment = .center
    label.textColor = UIColor.white
    label.sizeToFit()
    
    var stack = UIStackView()//(frame: messageView.bounds)
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
  
    return messageView
  }()
  
  internal static func animateIndicator(with message: String? = nil,`true`: Bool) {
    messageView.subviews.forEach({ aView in
      aView.subviews.forEach({ bView in
        if let  label = bView as? UILabel {
          label.text = message
        }
        if let indicator = bView as? UIActivityIndicatorView {
          if `true` {
            indicator.startAnimating()
          } else {
            indicator.stopAnimating()
          }
        }
      })
    })
  }
  
  public static func show(with message: String? = nil) {
    if let window = UIApplication.shared.keyWindow {
      let found = window.subviews.flatMap{$0.tag == 99}.contains(true)
      guard !found else {
        return
      }
      
      messageView.alpha = 0.5
      window.addSubview(messageView)
      
      animateIndicator(with: message, true: true)
      
      messageView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
      messageView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
      messageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
      messageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
      
//      messageView.indicator.startAnimating()
      messageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      UIView.animate(withDuration: 0.3, animations: {
        self.messageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.messageView.alpha = 1
        }, completion: nil)
    }
  }
  
  public static func hide() {
    UIView.animate(withDuration: 0.3, animations: { 
      messageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      messageView.alpha = 0
      }) { (completed) in
        messageView.transform = CGAffineTransform.identity
        animateIndicator(true: false)
        messageView.removeFromSuperview()
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
