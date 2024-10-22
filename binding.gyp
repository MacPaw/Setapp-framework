{
  "variables": {
    "module_name": "node_setapp_binding",
    "module_root": "nodejs",
    "module_bindnings_path": "nodejs/lib/binding",
    "path_for_nodejs_package": "nodejs/lib/binding",
    "setapp_framework_path": "Setapp.xcframework",
    "setapp_macos_library_path": "<(setapp_framework_path)/macos-arm64_x86_64"
  },
  "targets": [
    {
      "target_name": "<(module_name)",
      "sources": [
        "<(module_root)/deps/setapp-binding.mm"
      ],
      "dependencies": [
        "<!(node -p \"require('node-addon-api').gyp\")"
      ],
      "include_dirs": [
        "<!@(node -p \"require('node-addon-api').include\")",
        "<(setapp_macos_library_path)/Headers"
      ],
      "conditions": [
        [
          "OS=='mac'",
          {
            "link_settings": {
              "libraries": [
                "$(SDKROOT)/System/Library/Frameworks/AppKit.framework",
                "$(SDKROOT)/System/Library/Frameworks/Security.framework",
                "$(SDKROOT)/System/Library/Frameworks/Cocoa.framework",
                "$(SDKROOT)/System/Library/Frameworks/Foundation.framework",
                "-Wl,-rpath,/usr/lib/swift",
                "-L../<(setapp_macos_library_path)",
                "-lSetapp"
              ]
            },
            "xcode_settings": {
              "ONLY_ACTIVE_ARCH": "NO",
              "VALID_ARCHS": "arm64 x86_64",
              "OTHER_LDFLAGS": [
                "$(inherited)",
                "-force_load ../<(setapp_macos_library_path)/libSetapp.a",
                "-ObjC",
                "-arch x86_64",
                "-arch arm64"
              ],
              "OTHER_CFLAGS": [
                "-arch x86_64",
                "-arch arm64"
              ],
              "MACOSX_DEPLOYMENT_TARGET": "12.0",
              "GCC_ENABLE_CPP_EXCEPTIONS": "YES"
            }
          }
        ]
      ]
    },
    {
      "target_name": "action_after_build",
      "type": "none",
      "dependencies": [
        "<(module_name)"
      ],
      "copies": [
        {
          "files": [
            "<(PRODUCT_DIR)/<(module_name).node"
          ],
          "destination": "<(module_bindnings_path)"
        }, 
        {
          "files": [
            "<(PRODUCT_DIR)/<(module_name).node"
          ],
          "destination": "<(path_for_nodejs_package)"
        }
      ]
    }
  ]
}