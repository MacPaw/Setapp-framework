Pod::Spec.new do |s|
  s.name                    = 'Setapp'
  s.version                 = '0.2.1'

  s.summary                 = 'Setapp iOS Framework'

  s.homepage                = 'https://setapp.com/developers'

  s.author                  = 'Setapp Limited'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :git => "https://github.com/MacPaw/Setapp-framework.git", :tag => s.version }

  s.swift_version           = '5.3.1'
  s.requires_arc            = true

  s.ios.deployment_target   = '10.0'
  s.ios.frameworks          = 'Security', 'UIKit'
  s.ios.vendored_frameworks = 'Setapp.xcframework'
end
