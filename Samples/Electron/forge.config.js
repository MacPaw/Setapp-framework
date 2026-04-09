const path = require('path');

module.exports = {
  packagerConfig: {
    name: 'Setapp Electron App Demo',
    appBundleId: 'com.setapp.fmwk.macos.TestApp-setapp',
    appVersion: '0.0.1',
    buildVersion: '32',
    icon: path.resolve(__dirname, 'app/res/SetappIcon'),
    asar: true,
    appCategoryType: 'public.app-category.developer-tools',
    osxSign: {
      entitlements: path.resolve(__dirname, 'scripts/entitlements.mac.plist'),
      'entitlements-inherit': path.resolve(__dirname, 'scripts/entitlements.mac.plist'),
    },
    osxNotarize: process.env.NOTARIZE === 'true'
      ? {
          appleApiKey: process.env.APP_STORE_CONNECT_API_KEY_KEY_ID,
          appleApiIssuer: process.env.APP_STORE_CONNECT_API_KEY_ISSUER_ID,
        }
      : undefined,
    extraResource: [
      path.resolve(__dirname, 'app/res/setappPublicKey.pem'),
    ],
    ignore: [
      /node_modules\/@setapp\/framework-wrapper\/Setapp\.xcframework/,
      /node_modules\/@setapp\/framework-wrapper\/build\/node_gyp_bins\/python3/,
      /node_modules\/@setapp\/framework-wrapper\/bin\/.*\.node/,
      /node_modules\/.*\.(mk|a|o|h|forge-meta)$/,
      /^\/scripts/,
      /^\/dist/,
    ],
    extendInfo: {
      NSUpdateSecurityPolicy: {
        AllowProcesses: {
          MEHY5QF425: [
            'com.setapp.DesktopClient.SetappAgent',
          ],
        },
      },
    },
  },
  rebuildConfig: {
    onlyModules: [],
  },
  makers: [
    {
      name: '@electron-forge/maker-zip',
      platforms: ['darwin'],
    },
    {
      name: '@electron-forge/maker-dmg',
      platforms: ['darwin'],
      config: {
        format: 'ULFO',
      },
    },
  ],
  plugins: [
    {
      name: '@electron-forge/plugin-auto-unpack-natives',
      config: {},
    },
  ],
};
