//
//  SceneDelegate.swift
//  UIKit Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

import UIKit
import Setapp

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        SetappManager.logLevel = .verbose
        
        SetappManager.shared.start(
            with: SetappConfiguration(
                publicKeyBundle: .main,
                publicKeyFilename: "setappPublicKey-iOS.pem"
            )
        )
        
        openURLContexts(connectionOptions.urlContexts)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        openURLContexts(URLContexts)
    }
    
}

// MARK: Helpers

private extension SceneDelegate {
    
    func openURLContexts(_ URLContexts: Set<UIOpenURLContext>) {
        if SetappManager.shared.canOpen(urlContexts: URLContexts) {
            SetappManager.shared.open(urlContexts: URLContexts)
        }
    }
    
}

