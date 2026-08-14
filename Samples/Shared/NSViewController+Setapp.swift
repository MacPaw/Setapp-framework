//
//  NSViewController+Setapp.swift
//  Setapp Samples
//
//  Created by Сергій Попов on 01.11.2022.
//

import AppKit
import Setapp

extension NSViewController {
    @IBAction func presentAuthCodeAlert(_: NSButton) {
        let textFieldsWidth: CGFloat = 280

        let clientIDTextField = NSTextField(frame: NSRect(x: 0, y: 2, width: textFieldsWidth, height: 24))
        clientIDTextField.placeholderString = "Client ID"
        clientIDTextField.isEditable = true

        let textFieldsContainer = NSStackView(frame: NSRect(x: 0, y: 0, width: textFieldsWidth, height: 28))
        textFieldsContainer.orientation = .vertical
        textFieldsContainer.spacing = 8
        textFieldsContainer.addSubview(clientIDTextField)

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

            SetappManager.shared.requestAuthorizationCode(clientID: clientID) { result in
                DispatchQueue.main.async {
                    let alert: NSAlert

                    switch result {
                    case let .success(code):
                        alert = NSAlert()
                        alert.alertStyle = .informational
                        alert.messageText = "Received Code: \(code)"
                    case let .failure(error):
                        alert = NSAlert(error: error)
                        alert.alertStyle = .warning
                    }

                    alert.beginSheetModal(for: window)
                }
            }
        }
    }

    @IBAction func showReleaseNotes(_: Any) {
        SetappManager.shared.showReleaseNotesWindow()
    }

    @IBAction func askForEmail(_: Any) {
        SetappManager.shared.askUserToShareEmail()
    }

    @IBAction func showHelp(_: NSButton) {
        if let setappURL = URL(string: "https://docs.setapp.com") {
            NSWorkspace.shared.open(setappURL)
        }
    }
}
