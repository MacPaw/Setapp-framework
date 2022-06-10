//
//  LogsSmallView.swift
//  SetappSample-Catalyst
//
//  Created by Aleksandr.Bilous on 29.04.2022.
//

import Foundation
import UIKit

final class LogsSmallView: UIView {
  private lazy var logsView = LogTextView()
  
  private lazy var logsBackgroundView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 10
    view.backgroundColor = .white
    return view
  }()
  
  private lazy var showLogsButton: UIButton = {
    let button: UIButton
#if targetEnvironment(macCatalyst)
      button = UIButton(type: .custom)
#else
      button = UIButton(type: .system)
#endif
    button.setAttributedTitle(NSAttributedString(string: "Show logs", attributes: [
      .font: UIFont.systemFont(ofSize: 17, weight: .regular),
      .foregroundColor: UIColor.systemBlue
    ]), for: .normal)
    button.addTarget(self, action: #selector(showLogsButtonDidSelect(_:)), for: .touchUpInside)
    return button
  }()
  
  init()
  {
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Actions
private
extension LogsSmallView {
  @objc func showLogsButtonDidSelect(_ sender: UIButton?) {
    let logsViewController = LogsViewController()
    (UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?
        .pushViewController(logsViewController, animated: true)
  }
}

// MARK: - Setup UI
private
extension LogsSmallView {
  func setupUI()
  {
    [logsBackgroundView, showLogsButton, logsView].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    NSLayoutConstraint.activate([
      logsBackgroundView.topAnchor.constraint(equalTo: topAnchor),
      logsBackgroundView.leftAnchor.constraint(equalTo: leftAnchor),
      logsBackgroundView.rightAnchor.constraint(equalTo: rightAnchor),
      logsBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      logsView.topAnchor.constraint(equalTo: logsBackgroundView.topAnchor, constant: 17),
      logsView.leftAnchor.constraint(equalTo: logsBackgroundView.leftAnchor, constant: 22),
      logsView.rightAnchor.constraint(equalTo: logsBackgroundView.rightAnchor, constant: -22),
      logsView.heightAnchor.constraint(equalToConstant: 132),
      
      showLogsButton.bottomAnchor.constraint(equalTo: logsBackgroundView.bottomAnchor, constant: -14),
      showLogsButton.centerXAnchor.constraint(equalTo: logsBackgroundView.centerXAnchor),
    ])
  }
}
