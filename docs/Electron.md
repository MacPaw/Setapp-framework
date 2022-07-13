# Setapp Framewrok Node.js wrapper

1. [Add `@setapp/framework-wrapper` to your project](#add-setappframework-wrapper-to-your-project)
1. [Set an app bundle ID](#set-an-app-bundle-id)
1. [Add a public key to your app](#add-a-public-key-to-your-app)
1. [Allow Setapp to update your app](#allow-setapp-to-update-your-app)
1. [Use Setapp Framework](#use-setapp-framework)
1. [Integration sample](#integration-sample)

## Add `@setapp/framework-wrapper` to your project

1. Add our node package to your dependencies.
    ##### package.json
    ```diff
    {
      "dependencies": {
    +   "@setapp/framework-wrapper": "^2.0.6",
        ...
      },
    }
    ```

1. To rebuild the native module to the currently installed Electron version you should have `22.14.3` electron-builder version developer dependency. Also, you will need to add the `postinstall` script hook.
    ##### package.json
    ```diff
    {
      "devDependencies": {
    +   "electron-builder": "^22.14.3",
        ...
      },
      ...
      "scripts": {
        "start": "electron .",
        "build": "electron-builder --mac",
    +   "postinstall": "electron-builder install-app-deps",
        ...
      },
      ...
    }
    ```

1. To build a univarsal binary with (arm64 & x86_64 architectures) - specify the `--universal` parameter for the `electron-builder`
    ##### package.json
    ```diff
    {
      ...
      "scripts": {
        "start": "electron .",
    -    "build": "electron-builder --mac",
    +    "build": "electron-builder --mac --universal",
        "postinstall": "electron-builder install-app-deps"
      },
      ...
    }
    ```

## Set an app bundle ID

Add `-setapp` suffix to your app identifier.
  ##### package.json
  ```diff
  {
    "build": {
  +   "appId": "com.setapp.fmwk.macos.TestApp-setapp",
      ...
    }
  }
  ```

## Add a public key to your app

1. Download Setapp Public key (a note on the right from the release info).
1. Put the downloaded `setappPublicKey.pem` file to the package resources folder.
1. Add downloaded resource to extraResorces
    ##### package.json
    ```diff
    {
      "build": {
        "mac": {
          "extraResources": [
   +       {
   +         "from": "./res/setappPublicKey.pem",
   +         "to": "setappPublicKey.pem"
   +       }
          ...
          ],
        },
      }
    }
    ```

## Allow Setapp to update your app

In macOS 13 (Ventura) Apple introduced a new Privacy Restrictions. Thus to allow Setapp to update your app, you need to add the `NSUpdateSecurityPolicy` key to Info.plist of your resulting app. You can do it by adding the following lines to your `package.json` file:
  #### package.json
  ```diff
  {
    "build": {
      "mac": {
        "extendInfo": {
  +       "NSUpdateSecurityPolicy": {
  +         "AllowProcesses": {
  +           "MEHY5QF425": [
  +             "com.setapp.DesktopClient.SetappUpdater"
  +           ]
  +         }
  +       }
          ...
        },
      }
    }
  }
  ```

## Use Setapp Framework

Use `setapp` package in your Electron app project:
  ##### main.js
  ```js
  ...
  const { SetappManager, SETAPP_USAGE_EVENT, SETAPP_LOG_LEVEL } = require('@setapp/framework-wrapper');
  ...
  ```

We made Node.js wrapper API similar to the Setapp Framework macOS Swift API.
For example, to present a release notes window in your app, you can use `SetappManager.shared.showReleaseNotesWindow()`. So you can easy refer to the macOS methods.


## Integration sample

You can locate Electron integration sample in the [Samples/Electron](./../Samples/Electron) folder.
