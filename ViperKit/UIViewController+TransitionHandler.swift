//
//  UIViewController+TransitionHandler.swift
//  ViperKit
//
//  Created by Руслан Болатаев on 11/03/2017.
//  Copyright © 2017 Lead Group. All rights reserved.
//

import UIKit

extension UIViewController {
  private static let moduleInputAssociatedObjectKey = ""
}

extension UIViewController: TransitionHandler {
  public var moduleInput: ModuleInput? {
    get {
      var result = objc_getAssociatedObject(self, UIViewController.moduleInputAssociatedObjectKey) as? ModuleInput
      if result == nil {
        let mirror = Mirror(reflecting: self)
        let outputMirror = mirror.children.first { $0.label == "output" }
        let value = outputMirror?.value as AnyObject
        result = value as? ModuleInput
      }
      return result
    }
    
    set {
      objc_setAssociatedObject(self, UIViewController.moduleInputAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  public func openModule(_ segueIdentifier: String) {
    performSegue(withIdentifier: segueIdentifier, sender: nil)
  }
  
  public func openModule(_ segueIdentifier: String!, configurationBlock: ConfigurationBlock!) {
    performSegue(withIdentifier: segueIdentifier, sender: configurationBlock)
  }
  
  public func closeCurrentModule(animated: Bool) {
    let isInNavigationStack = parent is UINavigationController
    let hasManyControllersInStack = isInNavigationStack
      ? (parent as! UINavigationController).childViewControllers.count > 1
      : false
    
    if isInNavigationStack && hasManyControllersInStack {
      let navigationController = parent as! UINavigationController
      navigationController.popViewController(animated: animated)
    } else if presentingViewController != nil {
      dismiss(animated: animated, completion: nil)
    } else if view.superview != nil {
      removeFromParentViewController()
      view.removeFromSuperview()
    }
  }
}
