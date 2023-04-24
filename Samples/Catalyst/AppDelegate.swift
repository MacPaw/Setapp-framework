//
//  AppDelegate.swift
//  Catalyst Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

import UIKit
import Setapp

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    #if !targetEnvironment(macCatalyst)
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        if SetappManager.isSetappBackgroundSessionIdentifier(identifier) {
            SetappManager.shared.backgroundSessionCompletionHandler = completionHandler
        }
    }
    #endif

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

