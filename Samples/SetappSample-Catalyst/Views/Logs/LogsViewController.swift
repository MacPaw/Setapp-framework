//
//  LogsViewController.swift
//  SetappSample-Catalyst
//
//  Created by Aleksandr.Bilous on 29.04.2022.
//

import UIKit

final class LogsViewController: UIViewController {
  private var logsTextView: LogTextView!
  
  override func loadView() {
    super.loadView()
    setUpUI()
  }
}

private extension LogsViewController {
  @objc func didPressShareButton(_ sender: UIBarButtonItem) {
    let logs = LogTextViewTextProvider.shared.logs.reduce(into: "") {
      $0 += "[\($1.logLevel.description)] \($1.message)\n"
    }
    let activityVC = UIActivityViewController(activityItems: [logs], applicationActivities: .none)
    activityVC.excludedActivityTypes = [
      .postToFacebook,
      .postToTwitter,
      .postToWeibo,
      .message,
      .mail,
      .print,
      .assignToContact,
      .saveToCameraRoll,
      .addToReadingList,
      .postToFlickr,
      .postToVimeo,
      .postToTencentWeibo,
      .airDrop,
      .openInIBooks
    ]

    present(activityVC, animated: true, completion: .none)
  }
}

private extension LogsViewController {
  func setUpUI() {
    title = "Logs"
    view.backgroundColor = .white
    setUpLogTextView()
    setUpShareButton()
  }

  func setUpLogTextView() {
    let logsTextView = LogTextView()
    view.addSubview(logsTextView)
    logsTextView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      logsTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
      logsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
      logsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
      logsTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36)
    ])

    self.logsTextView = logsTextView
  }

  func setUpShareButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .action,
      target: self,
      action: #selector(didPressShareButton(_:))
    )
  }
}
