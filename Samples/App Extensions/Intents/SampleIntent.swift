//
//  AppIntents.swift
//  AppIntents
//
//  Created by Oleksandr Bilous on 14.08.2024.
//

import AppIntents
import Setapp

struct SampleIntent: AppIntent {
    static var title: LocalizedStringResource = "Sample Intent"

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        SetappManager.shared.reportExtensionUsage()
        return .result(value: "Sample Intent")
    }
}
