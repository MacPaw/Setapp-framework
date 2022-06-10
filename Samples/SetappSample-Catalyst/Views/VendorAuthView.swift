//
//  VendorAuthView.swift
//  SetappSample-Catalyst
//
//  Created by Aleksandr.Bilous on 29.04.2022.
//

import Foundation
import UIKit

final class VendorAuthView: UIView {
  private lazy var clientIDTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "Client ID"
    return textField
  }()
  
  private lazy var scopeIDTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "Scope (Space Separated)"
    return textField
  }()
  
  private lazy var requestButton: UIButton = {
    let button: UIButton
#if targetEnvironment(macCatalyst)
      button = UIButton(type: .custom)
#else
      button = UIButton(type: .system)
#endif
    button.setAttributedTitle(NSAttributedString(string: "Request", attributes: [
      .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
      .foregroundColor: UIColor.white
    ]), for: .normal)
    button.layer.cornerRadius = 8
    button.layer.backgroundColor = UIColor.systemBlue.cgColor
    button.addTarget(self, action: #selector(requestVendorAuthCode(_:)), for: .touchUpInside)
    return button
  }()
  
  private lazy var errorLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .systemRed
    label.isHidden = true
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    setupUI()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  var requestButtonActionHandler: ((String, String) -> ())?
}

// MARK: - Actions
extension VendorAuthView {
  func showResultLabel(with text: String, isError: Bool) {
    DispatchQueue.main.async { [weak errorLabel] in
      errorLabel?.isHidden = false
      errorLabel?.textColor = isError ? .systemRed : .systemGreen
      errorLabel?.text = text
    }
  }
  
  @objc func requestVendorAuthCode(_ sender: UIButton) {
    guard let clientID = clientIDTextField.text?.trimmingCharacters(in: .whitespaces),
          let scopeString = scopeIDTextField.text?.trimmingCharacters(in: .whitespaces) else {
      return
    }
    
    requestButtonActionHandler?(clientID, scopeString)
  }
}

// MARK: - Setup UI
private
extension VendorAuthView {
  func setupUI() {
    setupClientIDTextField()
    setupScopeTextField()
    setupErrorLabel()
    setupRequestButton()
  }
  
  func setupClientIDTextField() {
    addSubview(clientIDTextField)
    clientIDTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      clientIDTextField.topAnchor.constraint(equalTo: topAnchor),
      clientIDTextField.leftAnchor.constraint(equalTo: leftAnchor),
      clientIDTextField.rightAnchor.constraint(equalTo: rightAnchor),
      clientIDTextField.heightAnchor.constraint(equalToConstant: 36),
      clientIDTextField.widthAnchor.constraint(equalTo: widthAnchor)
    ])
  }
  
  func setupScopeTextField() {
    addSubview(scopeIDTextField)
    scopeIDTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scopeIDTextField.topAnchor.constraint(equalTo: clientIDTextField.bottomAnchor, constant: 15),
      scopeIDTextField.leftAnchor.constraint(equalTo: leftAnchor),
      scopeIDTextField.rightAnchor.constraint(equalTo: rightAnchor),
      scopeIDTextField.heightAnchor.constraint(equalToConstant: 36),
      scopeIDTextField.widthAnchor.constraint(equalTo: clientIDTextField.widthAnchor)
    ])
  }
  
  func setupErrorLabel() {
    addSubview(errorLabel)
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      errorLabel.topAnchor.constraint(equalTo: scopeIDTextField.bottomAnchor, constant: 10),
      errorLabel.leftAnchor.constraint(equalTo: scopeIDTextField.leftAnchor),
    ])
  }
  
  func setupRequestButton() {
    addSubview(requestButton)
    requestButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      requestButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10),
      requestButton.leftAnchor.constraint(equalTo: leftAnchor),
      requestButton.rightAnchor.constraint(equalTo: rightAnchor),
      requestButton.heightAnchor.constraint(equalToConstant: 50),
      requestButton.widthAnchor.constraint(equalTo: clientIDTextField.widthAnchor),
      requestButton.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}
