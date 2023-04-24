//
//  UIViewController+Setapp.swift
//  Setapp Samples
//
//  Created by Сергій Попов on 01.11.2022.
//

import UIKit
import Setapp

extension UIViewController {
    
    var targetName: String {
        Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    var optionsMenu: UIMenu {
        UIMenu(title: targetName, children: [
            UIAction(title: "Request Auth Code", image: UIImage(systemName: "curlybraces"), handler: { [weak self] action in
                self?.presentAuthCodeAlert()
            })
        ])
    }
    
}

extension UIViewController {
    
    @IBAction func presentAuthCodeAlert(_ sender: UIButton? = nil) {
        let alert = UIAlertController(title: "Request Auth Code", message: "Authorization code is used to access the Setapp server using Vendor API.", preferredStyle: .alert)
        
        alert.addTextField { clientIDTextField in
            clientIDTextField.placeholder = "Client ID"
            clientIDTextField.autocorrectionType = .no
            clientIDTextField.autocapitalizationType = .none
            clientIDTextField.tag = 0
        }
        
        alert.addTextField { scopeTextField in
            scopeTextField.placeholder = "Scope (Space Separated)"
            scopeTextField.autocorrectionType = .no
            scopeTextField.autocapitalizationType = .none
            scopeTextField.tag = 1
        }
        
        alert.addAction(.init(title: "Request", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            let clientID = alert.textFields?.first(where: { $0.tag == 0 })?.text ?? ""
            let scope = alert.textFields?.first(where: { $0.tag == 1 })?.text?.components(separatedBy: " ").compactMap(VendorAuthorizationScope.init(rawValue:)) ?? []
            
            SetappManager.shared.requestAuthorizationCode(clientID: clientID, scope: scope) { result in
                let alert: UIAlertController
                
                switch result {
                case .success(let code):
                    alert = UIAlertController(title: "Auth Code", message: code, preferredStyle: .alert)
                    alert.addAction(.init(title: "Copy", style: .default) { _ in
                        UIPasteboard.general.string = code
                    })
                case .failure(let error):
                    alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                }
                
                alert.addAction(.init(title: "Close", style: .cancel))
                
                self.present(alert, animated: true) {
                    sender?.isEnabled = true
                }
            }
        })
        
        alert.addAction(.init(title: "Cancel", style: .cancel) { _ in
            sender?.isEnabled = true
        })
        
        present(alert, animated: true)

        sender?.isEnabled = false
    }
    
    @IBAction func showHelp(_ sender: Any) {
        if let setappURL = URL(string: "https://docs.setapp.com") {
            UIApplication.shared.open(setappURL)
        }
    }
    
}

#if targetEnvironment(macCatalyst)

extension UIViewController {
    
    @IBAction func showReleaseNotes(_ sender: Any) {
        SetappManager.shared.showReleaseNotesWindow()
    }
    
    @IBAction func askForEmail(_ sender: Any) {
        SetappManager.shared.askUserToShareEmail()
    }
    
}

#endif
