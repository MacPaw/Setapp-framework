//
//  WindowController.m
//  SetappSamples
//
//  Created by Сергій Попов on 14.04.2023.
//

#import "WindowController.h"

@interface WindowController ()

@end

@implementation WindowController

- (IBAction)showHelp:(id)sender {
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://docs.setapp.com"]];
}

@end
