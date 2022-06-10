//
//  AppDelegate.m
//  SetappSample-macOS-ObjectiveC
//
//  Created by Aleksandr.Bilous on 22.04.2022.
//

#import "AppDelegate.h"
@import Setapp;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupSetappLogger];
    [[STPManager sharedInstance] showReleaseNotesWindowIfNeeded];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app
{
    return YES;
}

- (void)setupSetappLogger
{
    [STPManager setLogLevel:STPLogLevelVerbose];
    [STPManager setLogHandle:^(NSString * _Nonnull message, enum STPLogLevel logLevel) {
        NSLog(@"[Log level]: %ld, [message]: %@", logLevel, message);
    }];
}

@end
