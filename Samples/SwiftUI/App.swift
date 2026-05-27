//
//  App.swift
//  SwiftUI Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

import Setapp
import SwiftUI

@main
struct SetappSampleApp: App {
    init() {
        SetappManager.logLevel = .verbose

        #if os(iOS)
        let configuration = SetappConfiguration(
            publicKeyBundle: .main,
            publicKeyFilename: "setappPublicKey-iOS.pem",
            appGroupIdentifier: "group.setapp"
        )

        SetappManager.shared.start(
            with: configuration
        )
        #endif
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            #if os(iOS)
            .onOpenURL { url in
                if SetappManager.shared.canOpen(url: url) {
                    let _ = SetappManager.shared.open(url: url, options: [:])
                }
            }
            #endif
        }
    }
}
