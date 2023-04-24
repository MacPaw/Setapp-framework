//
//  SceneDelegate.m
//  UIKit Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

#import "SceneDelegate.h"

@import Setapp;

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    STPManager.logLevel = STPLogLevelVerbose;
    
    [STPManager.sharedInstance startWithConfiguration:[[STPConfiguration alloc] initWithPublicKeyBundle:NSBundle.mainBundle publicKeyFilename:@"setappPublicKey-iOS.pem"]];
    
    [self openURLContexts:connectionOptions.URLContexts];
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    [self openURLContexts:URLContexts];
}

#pragma mark Helpers

- (void)openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    if ([STPManager.sharedInstance canOpenURLContexts:URLContexts]) {
        [STPManager.sharedInstance openURLContexts:URLContexts completionHandler:^(STPSubscription * _Nullable subscription, NSError * _Nullable error) {
            NSLog(@"Setapp Activation Result: %@, error: %@", subscription, error);
        }];
    }
}

@end
