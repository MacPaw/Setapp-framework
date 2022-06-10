//
//  AppDelegate.swift
//  SetappSample-iOS
//
//  Created by Vitalii Budnik on 3/25/21.
//

import UIKit
import Setapp

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool
  {
    customiseSetappLogger()
    startSetappUsageReporting()
    return true
  }

  // MARK: UISceneSession Lifecycle

  @available(iOS 13.0, *)
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration
  {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

// MARK: - Setapp API Usage

extension AppDelegate {
  func customiseSetappLogger()
  {
    SetappManager.logLevel = .verbose
    SetappManager.setLogHandle { (logMessage, level) in
      print("[\(level.description)]", logMessage)
    }
  }
  
  func startSetappUsageReporting()
  {
#if !targetEnvironment(macCatalyst)
    SetappManager.shared.start(with: .init(publicKeyBundle: .main, publicKeyFilename: "setappPublicKey.iOS.pem"))
#endif
  }
}
