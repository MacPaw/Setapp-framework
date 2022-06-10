//
//  SubscriptionStatusView.swift
//  SetappSample-Catalyst
//
//  Created by Aleksandr.Bilous on 29.04.2022.
//

import UIKit

final class SubscriptionStatusView: UIView {
  private lazy var subscriptionStatusLabel: UILabel = {
    let label = UILabel()
    label.text = "Subscription status"
    label.font = UIFont.systemFont(ofSize: 17, weight: .light)
    return label
  }()
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 6
    return view
  }()
  
  private lazy var isActiveLabel: UILabel = {
    let label = UILabel()
    label.text = "Is active:"
    label.textColor = UIColor.black.withAlphaComponent(0.75)
    return label
  }()
  
  private lazy var expirationDateStatusLabel: UILabel = {
    let label = UILabel()
    label.text = "Expiration date:"
    label.textColor = UIColor.black.withAlphaComponent(0.75)
    return label
  }()
  
  private lazy var isActiveStatusLabel: UILabel = {
    let label = UILabel()
    label.text = "False"
    label.textColor = .red
    return label
  }()
  
  private lazy var expirationLabel: UILabel = {
    let label = UILabel()
    label.text = "-"
    label.textColor = .red
    return label
  }()
  
  private lazy var notificationLabel: UILabel = {
    let label = UILabel()
    label.text = "No notifications"
    label.textColor = .red
    return label
  }()
  
  private lazy var separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(named: "separatorColor")
    return view
  }()
  
  init() {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public API
extension SubscriptionStatusView {
  func updateSubscriptionState(_ state: String) {
    isActiveStatusLabel.text = state
  }
  
  func updateExpirationDate(_ date: Date?) {
    let newDate = date.flatMap { ISO8601DateFormatter().string(for: $0) } ?? "-"
    expirationLabel.text = newDate
  }
}

// MARK: - Setup View
private
extension SubscriptionStatusView {
  func setupView() {
    setupSubscriptionStatusLabel()
    setupContainerView()
    setupIsActiveField()
    setupExpirationDateField()
  }
  
  func setupSubscriptionStatusLabel() {
    addSubview(subscriptionStatusLabel)
    subscriptionStatusLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subscriptionStatusLabel.topAnchor.constraint(equalTo: topAnchor),
      subscriptionStatusLabel.leftAnchor.constraint(equalTo: leftAnchor),
    ])
  }
  
  func setupContainerView() {
    addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: subscriptionStatusLabel.bottomAnchor, constant: 22),
      containerView.leftAnchor.constraint(equalTo: leftAnchor),
      containerView.rightAnchor.constraint(equalTo: rightAnchor),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func setupIsActiveField() {
    [
      isActiveLabel,
      isActiveStatusLabel
    ].forEach {
      containerView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      isActiveLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
      isActiveLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 9),
      
      isActiveStatusLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
      isActiveStatusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 9),
    ])
  }
  
  func setupExpirationDateField() {
    let separator = self.separatorView
    [separator, expirationDateStatusLabel, expirationLabel].forEach {
      containerView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      separator.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
      separator.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
      separator.topAnchor.constraint(equalTo: isActiveLabel.bottomAnchor, constant: 9),
      separator.heightAnchor.constraint(equalToConstant: 1),
      
      expirationDateStatusLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
      expirationDateStatusLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 9),
      
      expirationLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
      expirationLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 9),
      expirationLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -9),
    ])
  }
}

