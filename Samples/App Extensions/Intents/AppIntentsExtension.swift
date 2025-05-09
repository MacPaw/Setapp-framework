//
//  AppIntentsExtension.swift
//  AppIntents
//
//  Created by Oleksandr Bilous on 14.08.2024.
//

import AppIntents
import Setapp

@main
struct SetappIntentsExtension: AppIntentsExtension {
    init() {
        configureSetappManager()
    }
    
    private func configureSetappManager() {
        SetappManager.logLevel = .debug

        let configuration = SetappConfiguration(
            publicKeyBundle: .main,
            publicKeyFilename: "setappPublicKey-iOS.pem"
        )
        
        configuration.appGroupIdentifier = "group.setapp"

        SetappManager.shared.start(
            with: configuration
        )
    }
}
