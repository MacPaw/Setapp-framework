//
//  ViewController.m
//  SetappSample-macOS-ObjectiveC
//
//  Created by Aleksandr.Bilous on 22.04.2022.
//

#import "ViewController.h"
#import "NSTextField+Extensions.h"
@import AppKit;
@import Setapp;

@interface ViewController()

@property (strong, nonatomic) NSTextField *clientIDInputField;
@property (strong, nonatomic) NSTextField *scopeInputField;
@property (strong, nonatomic) NSTextField *titleLabel;
@property (strong, nonatomic) NSTextField *descriptionLabel;
@property (strong, nonatomic) NSTextField *responseLabel;
@property (strong, nonatomic) NSImageView *logoView;
@property (strong, nonatomic) NSButton *requestButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark - Setapp library API usage

- (void)showReleaseNotes
{
    [[STPManager sharedInstance] showReleaseNotesWindow];
}

- (void)askUserToShareEmail
{
    [[STPManager sharedInstance] askUserToShareEmail];
}

- (void)requestAuthCode
{
    NSString *clientID = self.clientIDInputField.stringValue;
    NSArray<NSString *> *scope = [self.scopeInputField.stringValue componentsSeparatedByString:@" "];
    [[STPManager sharedInstance] requestAuthorizationCodeWithClientID:clientID
                                                                scope:scope
                                                    completionHandler:^(NSString * _Nullable result, NSError * _Nullable error) {
        self.responseLabel.stringValue = error ?
            [NSString stringWithFormat:@"❌ Failure:\n%@", [error description]] :
            [NSString stringWithFormat:@"✅ Success:\n%@", result];
    }];
}

#pragma mark - Setup View

- (void)setupView
{
    [self setupLogoView];
    [self setupTitleLabel];
    [self setupDescriptionLabel];
    [self setupClientIDInputField];
    [self setupScopeIDInputField];
    [self setupRequestButton];
    [self setupResponseLabel];
    [self setupShareEmailButton];
    [self setupReleaseNotesButton];
}

- (void)setupLogoView
{
    NSImageView *imageView = [NSImageView new];
    [self.view addSubview:imageView];
    imageView.image = [NSImage imageNamed:@"Small-logo"];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [imageView.heightAnchor constraintEqualToConstant:64],
        [imageView.widthAnchor constraintEqualToConstant:64],
        [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:22],
        [imageView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:22],
    ]];
    self.logoView = imageView;
}

- (void)setupTitleLabel
{
    self.titleLabel = [NSTextField label];
    self.titleLabel.stringValue = @"Setapp Client";
    self.titleLabel.font = [NSFont systemFontOfSize:16 weight:NSFontWeightBold];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.titleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:34],
        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.logoView.rightAnchor constant:21],
    ]];
}

- (void)setupDescriptionLabel
{
    self.descriptionLabel = [NSTextField label];
    self.descriptionLabel.stringValue = @"Integration with Setapp library";
    self.descriptionLabel.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
    self.descriptionLabel.textColor = [NSColor colorNamed:@"dynamicInverted90AlphaColor"];
    [self.descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.descriptionLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6],
        [self.descriptionLabel.leftAnchor constraintEqualToAnchor:self.titleLabel.leftAnchor],
    ]];
}

- (void)setupClientIDInputField
{
    self.clientIDInputField = [NSTextField editableField];
    [self.clientIDInputField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.clientIDInputField];
    [NSLayoutConstraint activateConstraints:@[
        [self.clientIDInputField.topAnchor constraintEqualToAnchor:self.descriptionLabel.bottomAnchor constant:20],
        [self.clientIDInputField.leftAnchor constraintEqualToAnchor:self.titleLabel.leftAnchor],
        [self.clientIDInputField.widthAnchor constraintEqualToConstant:485],
        [self.clientIDInputField.heightAnchor constraintEqualToConstant:26],
        [self.clientIDInputField.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-30],
    ]];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Client ID" attributes:@{
        NSFontAttributeName: [NSFont systemFontOfSize:13],
        NSForegroundColorAttributeName: NSColor.placeholderTextColor
    }];
    self.clientIDInputField.placeholderAttributedString = attrString;
}

- (void)setupScopeIDInputField
{
    self.scopeInputField = [NSTextField editableField];
    [self.scopeInputField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.scopeInputField];
    [NSLayoutConstraint activateConstraints:@[
        [self.scopeInputField.topAnchor constraintEqualToAnchor:self.clientIDInputField.bottomAnchor constant:10],
        [self.scopeInputField.leftAnchor constraintEqualToAnchor:self.clientIDInputField.leftAnchor],
        [self.scopeInputField.widthAnchor constraintEqualToAnchor:self.clientIDInputField.widthAnchor],
        [self.scopeInputField.heightAnchor constraintEqualToAnchor:self.clientIDInputField.heightAnchor]
    ]];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Scope (Space Separated)" attributes:@{
        NSFontAttributeName: [NSFont systemFontOfSize:13],
        NSForegroundColorAttributeName: NSColor.placeholderTextColor
    }];
    self.scopeInputField.placeholderAttributedString = attrString;
}

- (void)setupRequestButton
{
    self.requestButton = [NSButton new];
    [self.requestButton setTitle:@"Request"];
    [self.requestButton setBezelStyle:NSBezelStyleRounded];
    if (@available(macOS 10.14, *)) {
        self.requestButton.bezelColor = NSColor.controlAccentColor;
    }
    self.requestButton.font = [NSFont systemFontOfSize:13 weight:NSFontWeightMedium];
    self.requestButton.target = self;
    self.requestButton.action = @selector(requestAuthCode);
    [self.requestButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.requestButton];
    [NSLayoutConstraint activateConstraints:@[
        [self.requestButton.topAnchor constraintEqualToAnchor:self.scopeInputField.bottomAnchor constant:20],
        [self.requestButton.leftAnchor constraintEqualToAnchor:self.scopeInputField.leftAnchor],
        [self.requestButton.widthAnchor constraintEqualToConstant:72],
        [self.requestButton.heightAnchor constraintEqualToConstant:20],
    ]];
}

- (void)setupShareEmailButton
{
    NSButton *requestEmailButton = [NSButton new];
    [requestEmailButton setTitle:@"Share Email..."];
    [requestEmailButton setBezelStyle:NSBezelStyleRounded];
    requestEmailButton.target = self;
    requestEmailButton.action = @selector(askUserToShareEmail);
    
    [self.view addSubview:requestEmailButton];
    [requestEmailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [requestEmailButton.topAnchor constraintEqualToAnchor:self.requestButton.topAnchor],
        [requestEmailButton.leftAnchor constraintEqualToAnchor:self.requestButton.rightAnchor constant:167],
        [requestEmailButton.widthAnchor constraintEqualToConstant:105],
        [requestEmailButton.heightAnchor constraintEqualToConstant:20],
    ]];
}

- (void)setupReleaseNotesButton
{
    NSButton *showReleaseNotesButton = [NSButton new];
    [showReleaseNotesButton setTitle:@"Release Notes..."];
    [showReleaseNotesButton setBezelStyle:NSBezelStyleRounded];
    showReleaseNotesButton.target = self;
    showReleaseNotesButton.action = @selector(showReleaseNotes);
    
    [self.view addSubview:showReleaseNotesButton];
    [showReleaseNotesButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [showReleaseNotesButton.topAnchor constraintEqualToAnchor:self.requestButton.topAnchor],
        [showReleaseNotesButton.leftAnchor constraintEqualToAnchor:self.requestButton.rightAnchor constant:292],
        [showReleaseNotesButton.widthAnchor constraintEqualToConstant:122],
        [showReleaseNotesButton.heightAnchor constraintEqualToConstant:20],
    ]];
}

- (void)setupResponseLabel
{
    NSTextField *containerView = [NSTextField editableField];
    [containerView setEditable:NO];
    self.responseLabel = [NSTextField label];
    for (NSView *view in @[containerView, self.responseLabel])
    {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:view];
    }
        
    if (@available(macOS 10.15, *)) {
        self.responseLabel.font = [NSFont monospacedSystemFontOfSize:10 weight:NSFontWeightRegular];
    } else {
        self.responseLabel.font = [NSFont monospacedDigitSystemFontOfSize:10 weight:NSFontWeightRegular];
    }
    
    [NSLayoutConstraint activateConstraints:@[
        [containerView.topAnchor constraintEqualToAnchor:self.requestButton.bottomAnchor constant:30],
        [containerView.leftAnchor constraintEqualToAnchor:self.requestButton.leftAnchor],
        [containerView.widthAnchor constraintEqualToConstant:485],
        [containerView.heightAnchor constraintEqualToConstant:196],
        [containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-30],
        
        [self.responseLabel.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [self.responseLabel.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor],
        [self.responseLabel.widthAnchor constraintEqualToConstant:446],
        [self.responseLabel.heightAnchor constraintEqualToConstant:165],
    ]];
}

@end

