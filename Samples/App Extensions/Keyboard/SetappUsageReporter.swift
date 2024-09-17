//
//  SetappUsageReporter.swift
//  SetappKeyboard
//
//  Created by Oleksandr Bilous on 15.08.2024.
//

import Foundation
import Setapp

/// Wrapper to make sure SetappManager.start(:_) called only once.
final class SetappUsageReporter {
    static let shared: SetappUsageReporter = {
        SetappManager.logLevel = .debug

        let configuration = SetappConfiguration(
            publicKeyBundle: .main,
            publicKeyFilename: "setappPublicKey-iOS.pem"
        )
        
        configuration.appGroupIdentifier = "group.setapp"

        SetappManager.shared.start(
            with: configuration
        )
        return SetappUsageReporter()
    }()
    
    func reportExtensionUsage() {
        SetappManager.shared.reportExtensionUsage()
    }
}
