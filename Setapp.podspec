Pod::Spec.new do |s|
  s.name                    = 'Setapp'
  s.version                 = '2.0.1'

  s.summary                 = 'Setapp Framework'

  s.homepage                = 'https://setapp.com/developers'

  s.author                  = 'Setapp Limited'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :git => "https://github.com/MacPaw/Setapp-framework.git", :tag => s.version }

  s.swift_version           = '5.5.2'
  s.requires_arc            = true

  s.ios.deployment_target   = '10.0'
  s.ios.frameworks          = 'Security', 'UIKit'

  s.osx.deployment_target   = '10.10'
  s.osx.frameworks          = 'Security', 'AppKit'

  s.vendored_frameworks     = 'Setapp.xcframework'
end
