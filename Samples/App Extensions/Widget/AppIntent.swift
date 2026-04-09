//
//  AppIntent.swift
//  widget
//
//  Created by Oleksandr Bilous on 14.08.2024.
//

import AppIntents
import Setapp
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    /// An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
