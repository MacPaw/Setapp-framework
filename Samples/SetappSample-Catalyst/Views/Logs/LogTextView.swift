//
//  LogTextView.swift
//  SetappSample-Catalyst
//
//  Created by Aleksandr.Bilous on 29.04.2022.
//

import UIKit
import Setapp

final class LogTextView: UITextView {
  convenience init() {
    self.init(frame: .zero, textContainer: .none)
  }

  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setUp()
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    setUp()
  }

  func handleLogMessage(message: String, logLevel: SetappLogLevel, animated: Bool) {
    let shouldScrollToBottom = contentOffset.y + bounds.height >= contentSize.height
    text += "\n[\(logLevel.description)] \(message)\n"
    if animated && shouldScrollToBottom {
        scrollToBottom()
    }
  }

  func scrollToBottom() {
    scrollRangeToVisible(NSMakeRange(text.count - 1, 0))
  }

  func setPreviousLogs(_ logs: [(message: String, logLevel: SetappLogLevel)]) {
    logs.forEach { handleLogMessage(message: $0, logLevel: $1, animated: false) }
    scrollToBottom()
  }

  deinit {
    LogTextViewTextProvider.shared.deregister(self)
  }
}

private extension LogTextView {
  func setUp() {
      setUpUI()
      LogTextViewTextProvider.shared.register(self)
  }

  func setUpUI() {
      font = .monospacedSystemFont(ofSize: 14.0, weight: .regular)
      isEditable = false
  }
}
