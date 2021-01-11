Pod::Spec.new do |s|
  s.name                    = 'Setapp'
  s.version                 = '0.1.0'

  s.summary                 = 'Setapp iOS Framework'

  s.homepage                = 'https://setapp.com/developers'

  s.author                  = 'Setapp Limited'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :http => "https://github.com/MacPaw/Setapp-framework/releases/download/#{s.version.to_s}/Setapp.xcframework.zip",
                                :sha256 => 'cd1b0ac645c38d3463a59ad23eaa3a591a465f4554eaa3e5c5c59cbc3fda1298' }

  s.swift_version           = '5.3.1'
  s.requires_arc            = true

  s.ios.deployment_target   = '10.0'
  s.ios.frameworks          = 'Security', 'UIKit'
  s.ios.vendored_frameworks = 'Setapp.xcframework'
end
