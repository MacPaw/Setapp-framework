//
//  ContentView.swift
//  SetappSamples
//
//  Created by Сергій Попов on 14.04.2023.
//

import Foundation
import Setapp
import SwiftUI

struct ContentView: View {
    
    enum Alert {
        case authCodeRequest
        case authCodeResult(Result<String, Error>)
    }
    
    @State private var presentedAlert: Alert?
    
    @State private var clientID: String = ""
    @State private var scopes: String = ""
    
    @State private var isSetappSubscirptionActive: Bool?
    @State private var purchaseType: String?
    
    private var setappSubscriptionPublisher = SetappManager.shared.publisher(for: \.subscription)
    
    var body: some View {
        VStack {
            #if os(iOS)
            HStack {
                infoLabel()
                    .padding(.top, 10)
                    .padding(.leading, 16)
                Spacer()
            }
            #endif
            
            Spacer()
            subscriptionStatusView()
            Spacer()
            buttons()
            Spacer()
                .frame(height: 40)
        }
        .navigationTitle("Sample App")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Link(destination: URL(string: "https://docs.setapp.com")!) {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(Color("SecondaryControlColor"))
                }
            }
        }
        .alert(
            "Auth Code",
            isPresented: Binding(
                get: { presentedAlert != nil },
                set: { if $0 { presentedAlert = nil } }
            ),
            actions: alertActions,
            message: alertMessage
        )
        .onAppear {
            #if os(macOS)
            isSetappSubscirptionActive = true // on macOS if app is running it means Setapp subscription is valid

            SetappManager.shared.requestPurchaseType { result in
                switch result {
                case .success(let setappAppPurchaseType):
                    purchaseType = String(describing: setappAppPurchaseType)
                case .failure(let error):
                    purchaseType = "Unknown (\(error.localizedDescription))"
                }
            }
            #endif
        }
        .onReceive(setappSubscriptionPublisher) { subscription in
            isSetappSubscirptionActive = subscription?.isActive
        }
    }
}

extension ContentView {
    
    @ViewBuilder
    func infoLabel() -> some View {
        Text(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")
            .font(.system(size: 15))
            .foregroundColor(Color("SecondaryTextColor"))
    }
    
    @ViewBuilder
    func subscriptionStatusView() -> some View {
        VStack(spacing: 25) {
            if let isActive = isSetappSubscirptionActive {
                let imageName = isActive ? "checkmark.circle" : "x.circle"
                let statusText = "\(isActive ? "Active" : "Inactive") Setapp Subscription"
                
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundColor(isActive ? .green : .red)
                Text(statusText)
                    .font(.system(size: 15))
                    .foregroundColor(Color("SecondaryTextColor"))
            } else {
                Image(systemName: "qrcode")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundColor(.accentColor)
                Text("Activate via QR Code")
                    .font(.system(size: 15))
                    .foregroundColor(Color("SecondaryTextColor"))
            }
            if let purchaseType {
                Text("Distribution: \(purchaseType.capitalized)")
                    .font(.system(size: 13))
                    .foregroundColor(Color("SecondaryTextColor"))
            }
        }
    }
    
    @ViewBuilder
    func buttons() -> some View {
        #if os(iOS)
        Button {
            presentedAlert = .authCodeRequest
        } label: {
            Text("Request Auth Code")
                .font(.system(size: 15))
                .fontWeight(.medium)
                .frame(width: 228, height: 40)
        }
        .buttonStyle(.borderedProminent)
        #endif
        
        #if os(macOS)
        HStack {
            Button("Request Auth Code") {
                presentedAlert = .authCodeRequest
            }
            Button("Show Release Notes") {
                SetappManager.shared.showReleaseNotesWindow()
            }
            Button("Ask for Email") {
                SetappManager.shared.askUserToShareEmail()
            }
        }
        #endif
    }
    
    @ViewBuilder
    func alertMessage() -> some View {
        if let presentedAlert = presentedAlert {
            switch presentedAlert {
            case .authCodeRequest:
                Text("Authorization code is used to access the Setapp server using Vendor API.")
            case .authCodeResult(let result):
                switch result {
                case .success(let code):
                    Text(code)
                case .failure(let error):
                    Text(error.localizedDescription)
                }
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    func alertActions() -> some View {
        if let presentedAlert = presentedAlert {
            switch presentedAlert {
            case .authCodeRequest:
                TextField("Client ID", text: $clientID)
                TextField("Scopes (Space Separated)", text: $scopes)
                Button("Request") {
                    SetappManager.shared.requestAuthorizationCode(
                        clientID: clientID,
                        scope: scopes
                            .components(separatedBy: " ")
                            .compactMap(VendorAuthorizationScope.init(rawValue:))
                    ) { result in
                        self.presentedAlert = .authCodeResult(result)
                    }
                }
                Button("Cancel") {
                    self.presentedAlert = nil
                }
            case .authCodeResult(let result):
                if case .success(let code) = result {
                    Button("Copy") {
                        #if os(iOS)
                        UIPasteboard.general.string = code
                        #endif
                        #if os(macOS)
                        NSPasteboard.general.setString(code, forType: .string)
                        #endif
                        self.presentedAlert = nil
                    }
                }
                Button("Close") {
                    self.presentedAlert = nil
                }
            }
        } else {
            EmptyView()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
