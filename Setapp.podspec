Pod::Spec.new do |s|
  s.name                    = 'Setapp'
  s.version                 = '5.0.1'

  s.summary                 = 'Setapp Framework'

  s.homepage                = 'https://setapp.com/developers'

  s.author                  = 'Setapp Limited'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :git => "https://github.com/MacPaw/Setapp-framework.git", :tag => s.version }

  s.swift_version           = '6.2'
  s.requires_arc            = true

  s.resources = ['SetappFramework-Resources.bundle']

  s.ios.deployment_target   = '15.6'
  s.ios.frameworks          = 'Security', 'UIKit', 'Security'

  s.osx.deployment_target   = '11.5'
  s.osx.frameworks          = 'Security', 'AppKit', 'Security'

  s.vendored_frameworks     = 'Setapp.xcframework'
  s.static_framework        = true

  s.pod_target_xcconfig     = {
    'CODE_SIGNING_ALLOWED'    => 'NO'
  }

  s.user_target_xcconfig    = {
    'OTHER_LDFLAGS'           => "-force_load \"$(PODS_XCFRAMEWORKS_BUILD_DIR)/Setapp/libSetapp.a\"",
    'SWIFT_INCLUDE_PATHS'     => '$(PODS_XCFRAMEWORKS_BUILD_DIR)/Setapp',
    'LD_RUNPATH_SEARCH_PATHS' => '/usr/lib/swift'
  }

  s.script_phase = {
    :name => 'Create input OTHER_LDFLAGS files',
    :script => '# Takes care of "build input file cannot be found" failures with Xcode 15 and onwards, see for details: https://github.com/CocoaPods/CocoaPods/issues/12090',
    :execution_position => :before_compile,
    :output_files => ['${PODS_XCFRAMEWORKS_BUILD_DIR}/Setapp/libSetapp.a']
  }
end
