//
//  TransitionHandler.swift
//  ViperKit
//
//  Created by Руслан Болатаев on 11/03/2017.
//  Copyright © 2017 Lead Group. All rights reserved.
//

public typealias ConfigurationBlock = (ModuleInput?) -> ()

public protocol TransitionHandler: class {
  var moduleInput: ModuleInput? { get }
  
  func openModule(_ segueIdentifier: String)
  func openModule(_ segueIdentifier: String, configurationBlock: ConfigurationBlock)
  func closeCurrentModule(animated: Bool)
}

