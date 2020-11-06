Pod::Spec.new do |s|
  s.name                    = 'Setapp'
  s.version                 = '0.0.4'

  s.summary                 = 'Setapp iOS Framework'

  s.homepage                = 'https://setapp.com/developers'

  s.author                  = 'Setapp Limited'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :http => "https://github.com/MacPaw/Setapp-framework/releases/download/#{s.version.to_s}/Setapp.xcframework.zip",
                                :sha256 => '6b2101b443b546987369760873a1557df9e6ecef71ec492fa67eefb83bdcda7f' }

  s.swift_version           = '5.3.1'
  s.requires_arc            = true

  s.ios.deployment_target   = '10.0'
  s.ios.frameworks          = 'Security', 'UIKit'
  s.ios.vendored_frameworks = 'Setapp.xcframework'
end
