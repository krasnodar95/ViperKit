//
//  UIViewController+TransitionHandler.swift
//  ViperKit
//
//  Created by Руслан Болатаев on 11/03/2017.
//  Copyright © 2017 Lead Group. All rights reserved.
//

import UIKit

extension UIViewController {
  private static let tokenId = "UIViewController.prepareForSegue"
  private static let moduleInputAssociatedObjectKey = ""
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
  
  open override class func initialize () {
    swizzlePrepareForSegue()
  }
  
  private class func swizzlePrepareForSegue() {
    DispatchQueue.once(token: tokenId) {
      let prepareForSegueMethod = class_getInstanceMethod( self, #selector(prepare(for:sender:)) )
      let newPrepareForSegueMethod = class_getInstanceMethod( self, #selector(newPrepare(for:sender:)) )
      method_exchangeImplementations(prepareForSegueMethod, newPrepareForSegueMethod)
    }
  }
  
  @objc private func newPrepare(for segue: UIStoryboardSegue, sender: Any?) {
    newPrepare(for: segue, sender: sender)
    
    var destinationViewController: UIViewController? = segue.destination
    if let navController = destinationViewController as? UINavigationController {
      destinationViewController = navController.topViewController
    }
    
    if let destinationTransitionHandler = destinationViewController as? TransitionHandler,
      let destinationModuleInput = destinationTransitionHandler.moduleInput,
      let block = sender as? ConfigurationBlock {
      block(destinationModuleInput)
    }
  }
}

extension UIViewController: TransitionHandler {
  public func openModule(_ segueIdentifier: String) {
    performSegue(withIdentifier: segueIdentifier, sender: nil)
  }
  
  public func openModule(_ segueIdentifier: String, configurationBlock: ConfigurationBlock) {
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
