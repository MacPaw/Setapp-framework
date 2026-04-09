//
//  AppDelegate.swift
//  UIKit Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

import Setapp
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    func application(
        _: UIApplication,
        handleEventsForBackgroundURLSession identifier: String,
        completionHandler: @escaping () -> Void
    ) {
        if SetappManager.isSetappBackgroundSessionIdentifier(identifier) {
            SetappManager.shared.backgroundSessionCompletionHandler = completionHandler
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
