//
//  AppDelegate.m
//  UIKit Sample
//
//  Created by Сергій Попов on 27.10.2022.
//

#import "AppDelegate.h"

@import Setapp;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    if ([STPManager isSetappBackgroundSessionIdentifier:identifier]) {
        STPManager.sharedInstance.backgroundSessionCompletionHandler = completionHandler;
    }
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

@end
