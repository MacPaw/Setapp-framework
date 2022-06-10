//
//  SceneDelegate.swift
//  SetappSample-iOS
//
//  Created by Vitalii Budnik on 3/25/21.
//

import UIKit
import Setapp

@available(iOS 13.0, *)
@objc
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  )
  {
    prepareWindow()
    
#if !targetEnvironment(macCatalyst)
    SetappManager.shared.start(with: .init(publicKeyBundle: .main, publicKeyFilename: "setappPublicKey.iOS.pem"))
    if SetappManager.shared.canOpen(urlContexts: connectionOptions.urlContexts) {
      SetappManager.shared.open(urlContexts: connectionOptions.urlContexts) { result in
        switch result {
        case let .success(setappSubscription):
          print("Successfully unlocked new features!")
          print("Setapp subscription:", setappSubscription)
        case let .failure(error):
          print("Failed to unlock new app features due to the error:", error)
        }
      }
    }
#endif
  }

  func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  )
  {
#if !targetEnvironment(macCatalyst)
    if SetappManager.shared.canOpen(urlContexts: URLContexts) {
      SetappManager.shared.open(urlContexts: URLContexts) { result in
        switch result {
        case let .success(setappSubscription):
          print("Successfully unlocked new features!")
          print("Setapp subscription:", setappSubscription)
        case let .failure(error):
          print("Failed to unlock new app features due to the error:", error)
        }
      }
    }
#endif
  }
  
  private func prepareWindow() {
    let mainViewController = MainViewController()
    let navigationController = UINavigationController(rootViewController: mainViewController)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}
