//
//  ViewController.swift
//  UIKit Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

import UIKit
import Setapp

class ViewController: UIViewController {
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let targetName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        infoLabel.text = targetName
        
        update(with: SetappManager.shared.subscription)
        SetappManager.shared.delegate = self
    }
    
}

// MARK: Setapp

extension ViewController: SetappManagerDelegate {
    
    func setappManager(_ manager: SetappManager, didUpdateSubscriptionTo newSetappSubscription: SetappSubscription) {
        update(with: newSetappSubscription)
    }
    
}

// MARK: Helpers

private extension ViewController {
    
    func update(with subscription: SetappSubscription?) {
        if let subscription = subscription {
            statusImage.image = UIImage(systemName: subscription.isActive ? "checkmark.circle" : "x.circle")
            statusImage.tintColor = subscription.isActive ? .systemGreen : .systemRed
            statusLabel.text = "\(subscription.isActive ? "Active" : "Inactive") Setapp Subscription"
        } else {
            statusImage.image = UIImage(systemName: "qrcode")
            statusImage.tintColor = .tintColor
            statusLabel.text = "Activate via QR Code"
        }
    }
    
    func updateAppInfo() {
        let targetName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        infoLabel.text = targetName
    }
    
}
