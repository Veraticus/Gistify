//
//  AccountPreferencesController.h
//  Gistify
//
//  Created by Josh Symonds on 5/26/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "Gist.h"
#import "Constants.h"

@interface AccountPreferencesController : NSViewController <MASPreferencesViewController>

@property (assign) IBOutlet NSMatrix *radioButtons;
@property (assign) IBOutlet NSTextField *usernameLabel;
@property (assign) IBOutlet NSTextField *passwordLabel;
@property (assign) IBOutlet NSTextField *usernameField;
@property (assign) IBOutlet NSTextField *passwordField;
@property (assign) IBOutlet NSButton *button;

- (IBAction)pressButton:(id)sender;
- (IBAction)switchRadioButtons:(id)sender;

- (void)setupLoginWindow;

@end
