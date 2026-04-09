//
//  ViewController.swift
//  UIKit Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

import Setapp
import UIKit

class ViewController: UIViewController {
    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let targetName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        infoLabel.text = targetName

        update(with: SetappManager.shared.subscription)
        SetappManager.shared.delegate = self
    }
}

// MARK: - SetappManagerDelegate

extension ViewController: SetappManagerDelegate {
    func setappManager(_: SetappManager, didUpdateSubscriptionTo newSetappSubscription: SetappSubscription) {
        update(with: newSetappSubscription)
    }
}

// MARK: Helpers

extension ViewController {
    private func update(with subscription: SetappSubscription?) {
        if let subscription {
            statusImage.image = UIImage(systemName: subscription.isActive ? "checkmark.circle" : "x.circle")
            statusImage.tintColor = subscription.isActive ? .systemGreen : .systemRed
            statusLabel.text = "\(subscription.isActive ? "Active" : "Inactive") Setapp Subscription"
        } else {
            statusImage.image = UIImage(systemName: "qrcode")
            statusImage.tintColor = .tintColor
            statusLabel.text = "Activate via QR Code"
        }
    }

    private func updateAppInfo() {
        let targetName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        infoLabel.text = targetName
    }
}
