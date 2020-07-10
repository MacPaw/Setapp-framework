Pod::Spec.new do |s|
  s.name                    = 'Setapp'
  s.version                 = '0.0.2'

  s.summary                 = 'Setapp iOS Framework'

  s.homepage                = 'https://setapp.com/developers'

  s.author                  = 'Setapp Limited'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :http => "https://github.com/MacPaw/Setapp-framework/releases/download/#{s.version.to_s}/Setapp.framework.zip",
                                :sha256 => '7b2c069a3f72ad985a31aec23f1b37e088d60796548c6d0baae78a4e7ccebaa2' }

  s.swift_version           = '5.2.2'
  s.requires_arc            = true

  s.ios.deployment_target   = '10.0'
  s.ios.frameworks          = 'Security', 'UIKit'
  s.ios.vendored_frameworks = 'Setapp.framework'
end
