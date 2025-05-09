//
//  ToggleIntent.swift
//  widgetExtension
//
//  Created by Oleksandr Bilous on 14.08.2024.
//

import Foundation
import AppIntents
import Setapp

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct ToggleIntent: AppIntent {
    static var title: LocalizedStringResource = "User action"
    static var description = IntentDescription("Action element")
    
    func perform() async throws -> some IntentResult {
        SetappManager.shared.reportExtensionUsage()
        return .result()
    }
}
