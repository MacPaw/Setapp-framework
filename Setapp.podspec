Pod::Spec.new do |s|
  s.name                    = 'Setapp'
  s.version                 = '0.0.1'

  s.summary                 = 'Setapp iOS Framework'

  s.homepage                = 'https://setapp.com/developers'

  s.author                  = 'Setapp Limited'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :http => "https://github.com/MacPaw/Setapp-framework/releases/download/#{s.version.to_s}/Setapp.framework.zip",
                                :sha256 => '5cf31b6f942dd89933210329a9ae4ae087b8865d07b7257b61e0dd5965f9161f' }

  s.swift_version           = '5.2.2'
  s.requires_arc            = true

  s.ios.deployment_target   = '10.3'
  s.ios.frameworks          = 'Security', 'UIKit'
  s.ios.vendored_frameworks = 'Setapp.framework'
end
