//
//  NSViewController+Setapp.swift
//  Setapp Samples
//
//  Created by Сергій Попов on 01.11.2022.
//

import AppKit
import Setapp

extension NSViewController {
    
    @IBAction func presentAuthCodeAlert(_ sender: NSButton) {
        let textFieldsWidth: CGFloat = 280
        
        let clientIDTextField = NSTextField(frame: NSRect(x: 0, y: 2, width: textFieldsWidth, height: 24))
        clientIDTextField.placeholderString = "Client ID"
        clientIDTextField.isEditable = true
        
        let scopeTextField = NSTextField(frame: NSRect(x: 0, y: 28, width: textFieldsWidth, height: 24))
        scopeTextField.placeholderString = "Scopes (Space Separated)"
        scopeTextField.isEditable = true
        
        let textFieldsContainer = NSStackView(frame: NSRect(x: 0, y: 0, width: textFieldsWidth, height: 58))
        textFieldsContainer.orientation = .vertical
        textFieldsContainer.spacing = 8
        textFieldsContainer.addSubview(clientIDTextField)
        textFieldsContainer.addSubview(scopeTextField)
        
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "Request Auth Code"
        alert.informativeText = "Authorization code is used to access the Setapp server using Vendor API."
        alert.accessoryView = textFieldsContainer
        alert.addButton(withTitle: "Request")
        alert.addButton(withTitle: "Cancel")
        
        guard let window = view.window else { return }
        
        alert.beginSheetModal(for: window) { response in
            guard response == .alertFirstButtonReturn else { return }

            let clientID = clientIDTextField.stringValue
            let scope = scopeTextField.stringValue.components(separatedBy: " ").compactMap(VendorAuthorizationScope.init(rawValue:))
            
            SetappManager.shared.requestAuthorizationCode(clientID: clientID, scope: scope) { result in
                            
                let alert: NSAlert

                switch result {
                case .success(let code):
                    alert = NSAlert()
                    alert.alertStyle = .informational
                    alert.messageText = "Received Code: \(code)"
                case .failure(let error):
                    alert = NSAlert(error: error)
                    alert.alertStyle = .warning
                }
                    
                alert.beginSheetModal(for: window)
            }
        }
    }
    
    @IBAction func showReleaseNotes(_ sender: Any) {
        SetappManager.shared.showReleaseNotesWindow()
    }
    
    @IBAction func askForEmail(_ sender: Any) {
        SetappManager.shared.askUserToShareEmail()
    }
    
    @IBAction func showHelp(_ sender: NSButton) {
        if let setappURL = URL(string: "https://docs.setapp.com") {
            NSWorkspace.shared.open(setappURL)
        }
    }
    
}
