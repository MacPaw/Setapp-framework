//
//  WindowController.swift
//  SetappSamples
//
//  Created by Сергій Попов on 14.04.2023.
//

import AppKit

class WindowController: NSWindowController {

    @IBAction func showHelp(_ sender: Any) {
        if let setappURL = URL(string: "https://docs.setapp.com") {
            NSWorkspace.shared.open(setappURL)
        }
    }
    
}
