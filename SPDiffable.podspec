Pod::Spec.new do |s|

  s.name = 'SPDiffable'
  s.version = '1.3.5'
  s.summary = 'Extenshion of Diffable API which allow not duplicate code and use less models.'
  s.homepage = 'https://github.com/ivanvorobei/SPDiffable'
  s.source = { :git => 'https://github.com/ivanvorobei/SPDiffable.git', :tag => s.version }
  s.license = { :type => 'MIT', :file => "LICENSE" }
  s.author = { 'Ivan Vorobei' => 'hello@ivanvorobei.by' }
  
  s.swift_version = '5.1'
  s.ios.deployment_target = '12.0'

  s.source_files  = 'Sources/SPDiffable/**/*.swift'

end
