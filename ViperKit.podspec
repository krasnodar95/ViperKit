Pod::Spec.new do |s|
  s.name         = "ViperKit"
  s.version      = "0.1.1"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Ruslan Bolataev" => "krasnodar95@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.summary      = "ViperKit is a swift-framework for implementing VIPER architecture in iOS application. It is inspired by Objective-C framework - VIPER McFlurry https://github.com/rambler-digital-solutions/ViperMcFlurry"

  s.source       = { :git => "https://gitlab.com/leadgroup/viper-kit-ios.git", :tag => "#{s.version}" }
  s.homepage     = 'https://gitlab.com/leadgroup/viper-kit-ios.git'

  s.framework = "UIKit"

  s.source_files = "ViperKit/**/*.{swift,h,m}"
  s.requires_arc = true
end
