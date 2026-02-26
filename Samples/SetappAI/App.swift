import SwiftUI
import Setapp
import SetappAI

@main
struct SetappAISampleApp: App {

    init() {
        SetappManager.logLevel = .verbose

        #if os(iOS)
        let configuration = SetappConfiguration(
            publicKeyBundle: .main,
            publicKeyFilename: "setappPublicKey-iOS.pem"
        )
        configuration.appGroupIdentifier = "group.setapp"
        SetappManager.shared.start(with: configuration)
        #endif

        // auth client that is created in your vendor account
#if os(iOS)
        SetappManager.shared.ai.set(configuration: .init(
            authConfiguration: AuthConfiguration(
                oauthClientId: "ad82ea588b3a5899a82cafbbbadf6fde451d7d3bacac5dad",
                oauthSecret: "6PjJYWPTkMB1xU09XQq47QyP8rIltFTM0FZOSsZB"
            )
        ))
#else
        SetappManager.shared.ai.set(configuration: .init(
            authConfiguration: AuthConfiguration(
                oauthClientId: "28d128d2179763663a93bf6bc7232dd643a436094562023d",
                oauthSecret: "Eafev2YDhtXHjjLa5dgPYDSNRmdORUQ1nS72DXmo"
            )
        ))
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
