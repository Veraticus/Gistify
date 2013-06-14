//
//  AccountPreferencesController.m
//  Gistify
//
//  Created by Josh Symonds on 5/26/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "AccountPreferencesController.h"

@interface AccountPreferencesController ()

@end

@implementation AccountPreferencesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseLogin) name:@"pauseLogin" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unpauseLogin) name:@"unpauseLogin" object:nil];
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.radioButtons.intercellSpacing = NSMakeSize(5.0, 10.0);

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"anonymous"] isEqualToString:@"true"]) {
        [self.radioButtons selectCellWithTag:1];
    } else {
        [self.radioButtons selectCellWithTag:0];
    }
    [self setupLoginWindow];
}

- (IBAction)pressButton:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] == nil) {
        if ([self.usernameField.stringValue isEqualToString:@""] || [self.usernameField.stringValue isEqualToString:@""]) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:@"Please enter in both a username and password to log in."];
            [alert runModal];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.stringValue forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.stringValue forKey:@"password"];
            
            [[Gist singleton] authenticate];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"You are logged out."];
        [alert runModal];

        
        [self setupLoginWindow];
    }
}

- (IBAction)switchRadioButtons:(id)sender {
    if (self.radioButtons.selectedCell == [self.radioButtons cellWithTag:0]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"anonymous"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"anonymous"];
    }
    
    [self setupLoginWindow];
}

- (void)setupLoginWindow {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] == nil) {
        self.usernameField.stringValue = @"";
        self.passwordField.stringValue = @"";
        self.usernameField.enabled = YES;
        self.passwordField.enabled = YES;
        
        self.button.title = @"Login";
        
        [[self.radioButtons cellWithTag:0] setEnabled:NO];
        [self.radioButtons selectCellWithTag:1];
    } else {
        self.usernameField.stringValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        self.passwordField.stringValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        self.usernameField.enabled = NO;
        self.passwordField.enabled = NO;
        
        self.button.title = @"Logout";
        [[self.radioButtons cellWithTag:0] setEnabled:YES];
    }
}

- (void)pauseLogin {
    self.usernameField.enabled = NO;
    self.passwordField.enabled = NO;
    self.button.enabled = NO;
}

- (void)unpauseLogin {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] == nil) {
        self.usernameField.enabled = YES;
        self.passwordField.enabled = YES;
        self.button.enabled = YES;
        [self.passwordField becomeFirstResponder];
    } else {
        [self setupLoginWindow];
    }
}

#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"AccountPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameUserAccounts];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Account", @"GitHub account info");
}


@end
