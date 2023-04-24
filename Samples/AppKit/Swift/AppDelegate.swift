//
//  AppDelegate.swift
//  AppKit Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

import Cocoa
import Setapp

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        SetappManager.logLevel = .verbose
        SetappManager.shared.showReleaseNotesWindowIfNeeded()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
