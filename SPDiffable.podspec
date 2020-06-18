Pod::Spec.new do |s|

  s.name          = "SPDiffable"
  s.version       = "1.0.0"
  s.summary       = ""
  s.homepage      = "https://github.com/IvanVorobei/SPDiffable"
  s.source        = { :git => "https://github.com/IvanVorobei/SPDiffable.git", :tag => s.version }
  s.license       = { :type => "MIT", :file => "LICENSE" }
  
  s.author        = { "Ivan Vorobei" => "varabeis@icloud.com" }
  
  s.platform      = :ios
  s.ios.framework = 'UIKit'
  s.swift_version = ['4.2', '5.0']
  s.ios.deployment_target = "13.0"

  s.source_files  = "Source/SPDiffable/**/*.swift"

end
