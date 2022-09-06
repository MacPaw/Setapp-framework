Pod::Spec.new do |s|
  s.name                    = 'Setapp'
  s.version                 = '2.0.8'

  s.summary                 = 'Setapp Framework'

  s.homepage                = 'https://setapp.com/developers'

  s.author                  = 'Setapp Limited'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :git => "https://github.com/MacPaw/Setapp-framework.git", :tag => s.version }

  s.swift_version           = '5.6'
  s.requires_arc            = true

  s.ios.deployment_target   = '10.0'
  s.ios.frameworks          = 'Security', 'UIKit'
  s.ios.resource_bundles = {
    'SetappResources_iOS_cocoapods' => ['SetappFramework-Resources-iOS.bundle']
  }

  s.osx.deployment_target   = '10.10'
  s.osx.frameworks          = 'Security', 'AppKit'

  s.vendored_frameworks     = 'Setapp.xcframework'
  s.static_framework        = true

  s.user_target_xcconfig    = {
    'OTHER_LDFLAGS'       => "-force_load \"$(PODS_XCFRAMEWORKS_BUILD_DIR)/Setapp/libSetapp.a\"",
    'SWIFT_INCLUDE_PATHS' => '$(PODS_XCFRAMEWORKS_BUILD_DIR)/Setapp',
    'LD_RUNPATH_SEARCH_PATHS' => '/usr/lib/swift'
  }
end
