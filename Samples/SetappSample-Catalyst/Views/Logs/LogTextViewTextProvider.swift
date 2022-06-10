//
//  LogTextViewTextProvider.swift
//  SetappSample-Catalyst
//
//  Created by Aleksandr.Bilous on 29.04.2022.
//

import Foundation
import Setapp

final class LogTextViewTextProvider {
  static public let shared = LogTextViewTextProvider()

  private var boxes: [WeakBox<LogTextView>] = []
  private(set) var logs: [(message: String, logLevel: SetappLogLevel)] = []
  private var initialized: Bool = false

  private init() {
      setLogHandle()
  }

  private func setLogHandle() {
    guard !initialized else { return }
    initialized = true
    SetappManager.setLogHandle { (message, logLevel) in
      LogTextViewTextProvider.shared.boxes.forEach { (box) in
        LogTextViewTextProvider.shared.logs.append((message, logLevel))
        box.value?.handleLogMessage(message: message, logLevel: logLevel, animated: true)
        NSLog("[%@] %@", logLevel.description, message)
      }
    }
  }

  private func cleanBoxes() {
    boxes.removeAll { $0.value == .none }
  }

  func register(_ textView: LogTextView) {
    defer { cleanBoxes() }
    boxes.append(.init(value: textView))
    textView.setPreviousLogs(logs)
  }

  func deregister(_ textView: LogTextView) {
    defer { cleanBoxes() }
    guard let index = boxes.firstIndex(where: { $0.value === textView}) else {
        return
    }
    boxes.remove(at: index)
  }
}
