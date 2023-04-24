//
//  SceneDelegate.swift
//  Catalyst Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

import UIKit
import Setapp

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        SetappManager.logLevel = .verbose
        
        #if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbarStyle = .unified
        }
        #endif
        
        #if !targetEnvironment(macCatalyst)
        SetappManager.shared.start(
            with: SetappConfiguration(
                publicKeyBundle: .main,
                publicKeyFilename: "setappPublicKey-iOS.pem"
            )
        )
        openURLContexts(connectionOptions.urlContexts)
        #endif
    }
    
    #if !targetEnvironment(macCatalyst)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        openURLContexts(URLContexts)
    }
    #endif
    
}

// MARK: Helpers

#if !targetEnvironment(macCatalyst)
private extension SceneDelegate {
    
    func openURLContexts(_ URLContexts: Set<UIOpenURLContext>) {
        if SetappManager.shared.canOpen(urlContexts: URLContexts) {
            SetappManager.shared.open(urlContexts: URLContexts)
        }
    }
    
}
#endif

