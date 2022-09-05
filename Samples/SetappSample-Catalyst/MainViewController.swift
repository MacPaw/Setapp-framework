//
//  MainViewController.swift
//  SetappSample-iOS
//
//  Created by Vitalii Budnik on 3/25/21.
//

import UIKit
import Setapp

class MainViewController: UIViewController {
  private let scrollView = UIScrollView()
  private let vendorAuthView = VendorAuthView()
  private let logsView = LogsSmallView()
  private let subscriptionView = SubscriptionStatusView()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "Integration with Setapp library"
    label.font = .systemFont(ofSize: 17, weight: .light)
    label.textColor = .black
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    observeSetappSubscription()
    setupVendorAuthRequest()
  }
}

// MARK: - Setapp API

extension MainViewController {
  func setupVendorAuthRequest() {
    vendorAuthView.requestButtonActionHandler = { [weak vendorAuthView] (clientId, scopeString) in
      guard !clientId.isEmpty && !scopeString.isEmpty else {
        vendorAuthView?.showResultLabel(with: "Fields shouldn't be empty", isError: true)
        return
      }
      
      let scope = scopeString.components(separatedBy: " ").map { VendorAuthorizationScope(rawValue: $0) }
      
      SetappManager.shared.requestAuthorizationCode(
        clientID: clientId,
        scope: scope
      ) { result in
        switch result {
        case .success:
          vendorAuthView?.showResultLabel(with: "Success - see logs for code", isError: false)
        case .failure:
          vendorAuthView?.showResultLabel(with: "Failure - see logs for error", isError: true)
        }
      }
    }
  }
  
  func observeSetappSubscription() {
    readCurrentSetappSubscription()
    subscribeOnNotificationsChange()
  }

  func readCurrentSetappSubscription() {
#if !targetEnvironment(macCatalyst)
    let subscription = SetappManager.shared.subscription
    updateSubscriptionStatus(with: subscription)
#else
    subscriptionView.updateSubscriptionState("True")
#endif
  }
  
  func subscribeOnNotificationsChange() {
#if !targetEnvironment(macCatalyst)
    NotificationCenter.default.addObserver(
      forName: SetappManager.didChangeSubscriptionNotification,
      object: SetappManager.shared,
      queue: .main
    ) { [weak self] notification in
      guard let newValue = notification.userInfo?[NSKeyValueChangeKey.newKey] as? SetappSubscription else {
          return
      }
      
      self?.updateSubscriptionStatus(with: newValue)
    }
#endif
  }
}

// MARK: - Private API
private
extension MainViewController
{
    private func updateSubscriptionStatus(with newSetappSubscription: SetappSubscription?) {
        let subscriptionState = newSetappSubscription.flatMap { "\($0.isActive)" } ?? "undetermined"
        subscriptionView.updateSubscriptionState(subscriptionState)
        subscriptionView.updateExpirationDate(newSetappSubscription?.expirationDate)
    }
}

// MARK: - Setup UI
private
extension MainViewController {
  func setupUI() {
    setupNavigationBar()
    setupScrollView()
    setupDescriptionLabel()
    setupVendorAuthView()
    setupLogsView()
    setupSubscriptionStatusLabel()
  }
  
  func setupNavigationBar() {
    title = "Setapp Client"
    view.backgroundColor = UIColor(named: "backgroundColor")!
  }
  
  func setupScrollView() {
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  func setupDescriptionLabel() {
    scrollView.addSubview(descriptionLabel)
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
      descriptionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16)
    ])
  }
  
  func setupVendorAuthView() {
    scrollView.addSubview(vendorAuthView)
    vendorAuthView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vendorAuthView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
      vendorAuthView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
      vendorAuthView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
      vendorAuthView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
    ])
  }
  
  func setupLogsView() {
    scrollView.addSubview(logsView)
    logsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      logsView.topAnchor.constraint(equalTo: vendorAuthView.bottomAnchor, constant: 30),
      logsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
      logsView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
      logsView.heightAnchor.constraint(equalToConstant: 210)
    ])
  }
  
  func setupSubscriptionStatusLabel() {
    scrollView.addSubview(subscriptionView)
    subscriptionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subscriptionView.topAnchor.constraint(equalTo: logsView.bottomAnchor, constant: 40),
      subscriptionView.leftAnchor.constraint(equalTo: logsView.leftAnchor),
      subscriptionView.rightAnchor.constraint(equalTo: logsView.rightAnchor),
      subscriptionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60),
    ])
  }
}
