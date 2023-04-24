//
//  ViewController.m
//  UIKit Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

#import "ViewController.h"

@import Setapp;

@interface ViewController () <STPManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateInfoLabel];
    [self updateWithSubscription:STPManager.sharedInstance.subscription];
    
    STPManager.sharedInstance.delegate = self;
}

#pragma mark Setapp

- (void)setappManager:(STPManager *)manager didUpdateSubscriptionTo:(STPSubscription *)newSetappSubscription {
    [self updateWithSubscription:newSetappSubscription];
}

#pragma mark Helpers

- (void)updateWithSubscription:(STPSubscription *)subscription {
    if (subscription) {
        self.statusImage.image = [UIImage systemImageNamed:subscription.isActive ? @"checkmark.circle" : @"x.circle"];
        self.statusImage.tintColor = subscription.isActive ? UIColor.systemGreenColor : UIColor.systemRedColor;
        self.statusLabel.text = [NSString stringWithFormat:@"%@ Setapp Subscription", subscription.isActive ? @"Active" : @"Inactive"];
    }
    else {
        self.statusImage.image = [UIImage systemImageNamed:@"qrcode"];
        self.statusImage.tintColor = UIColor.tintColor;
        self.statusLabel.text = @"Activate via QR Code";
    }
}

- (void)updateInfoLabel {
    self.infoLabel.text = NSBundle.mainBundle.infoDictionary[@"CFBundleName"];
}

@end
