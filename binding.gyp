{
  "variables": {
    "module_name": "node_setapp_binding",
    "module_root": "nodejs",
    "module_bindnings_path": "nodejs/lib/binding",
    "setapp_framework_path": "Setapp.xcframework",
    "setapp_macos_library_path": "<(setapp_framework_path)/macos-arm64_x86_64",
    "openssl_fips": ""
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
            "xcode_settings": {
              "ONLY_ACTIVE_ARCH": "NO",
              "VALID_ARCHS": "arm64 x86_64",
              "OTHER_LDFLAGS": [
                "-force_load ../<(setapp_macos_library_path)/libSetapp.a",
                "-arch x86_64",
                "-arch arm64"
              ],
              "OTHER_CFLAGS": [
                "-arch x86_64",
                "-arch arm64"
              ],
              "MACOSX_DEPLOYMENT_TARGET": "10.13",
              "GCC_ENABLE_CPP_EXCEPTIONS": "YES",
              "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES": "YES",
              "LD_RUNPATH_SEARCH_PATHS": [
                "/usr/lib/swift",
                "@executable_path/../Frameworks",
                "@loader_path/../Frameworks"
              ]
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
        }
      ]
    }
  ]
}
