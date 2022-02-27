Pod::Spec.new do |s|

  s.name = 'SPDiffable'
  s.version = '4.0.8'
  s.summary = 'Extension of Diffable API which allow not duplicate code and use less models. Included example for SideBar.'
  s.homepage = 'https://github.com/ivanvorobei/SPDiffable'
  s.source = { :git => 'https://github.com/ivanvorobei/SPDiffable.git', :tag => s.version }
  s.license = { :type => 'MIT', :file => "LICENSE" }
  s.author = { 'Ivan Vorobei' => 'hello@ivanvorobei.io' }
  
  s.swift_version = '5.1'
  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'

  s.source_files  = 'Sources/SPDiffable/**/*.swift'

end
