//
//  App.swift
//  SwiftUI Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

import SwiftUI
import Setapp

@main
struct SetappSampleApp: App {
    
    init() {
        SetappManager.logLevel = .verbose
        
        #if os(iOS)
        SetappManager.shared.start(
            with: SetappConfiguration(
                publicKeyBundle: .main,
                publicKeyFilename: "setappPublicKey-iOS.pem"
            )
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
