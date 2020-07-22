Pod::Spec.new do |s|
  s.name                    = 'Setapp'
  s.version                 = '0.0.3'

  s.summary                 = 'Setapp iOS Framework'

  s.homepage                = 'https://setapp.com/developers'

  s.author                  = 'Setapp Limited'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :http => "https://github.com/MacPaw/Setapp-framework/releases/download/#{s.version.to_s}/Setapp.framework.zip",
                                :sha256 => 'b4ba51d7209e4d0571342b2c48c688e2651391f69e1e686779d22d22e1c2d89a' }

  s.swift_version           = '5.2.2'
  s.requires_arc            = true

  s.ios.deployment_target   = '10.0'
  s.ios.frameworks          = 'Security', 'UIKit'
  s.ios.vendored_frameworks = 'Setapp.framework'
end
