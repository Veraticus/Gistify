//
//  AppDelegate.m
//  Gistify
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import <ServiceManagement/ServiceManagement.h>

#import "AppDelegate.h"
#import "MenubarController.h"
#import "PreferencesController.h"
#import "ShortcutsController.h"
#import "ModalController.h"
#import "StartAtLoginController.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize preferencesController = _preferencesController;
@synthesize shortcutsController = _shortcutsController;
@synthesize menubarController = _menubarController;
@synthesize modalController = _modalController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Create preferences pane
    _preferencesController = [[PreferencesController alloc] init];
    
    // Setup shortcuts
    _shortcutsController = [[ShortcutsController alloc] init];
    
    // Setup menu
    _menubarController = [[MenubarController alloc] init];
    
    // Setup modal
    _modalController = [[ModalController alloc] initWithWindowNibName:@"Modal"];
 
    // First-time setup
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kGistifyGlobalShortcut]) {
        [self assignDefaults];
   }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"anonymous"]) {
        [self upgradeDefaults];
    }
    
    // Register for notifications
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)assignDefaults {
    StartAtLoginController *loginController = [[StartAtLoginController alloc] initWithIdentifier:@"com.joshsymonds.gistifyhelper"];
    loginController.startAtLogin = YES;
    loginController.enabled = YES;
    
    MASShortcut *gistifyCopiedText = [MASShortcut shortcutWithKeyCode:9 modifierFlags:NSShiftKeyMask|NSCommandKeyMask];
    NSData *gistifyCopiedTextData = [NSKeyedArchiver archivedDataWithRootObject:gistifyCopiedText];
    [[NSUserDefaults standardUserDefaults] setObject:gistifyCopiedTextData forKey:kGistifyGlobalShortcut];
    
    MASShortcut *gistifyCopiedTextAs = [MASShortcut shortcutWithKeyCode:9 modifierFlags:NSControlKeyMask|NSCommandKeyMask];
    NSData *gistifyCopiedTextAsData = [NSKeyedArchiver archivedDataWithRootObject:gistifyCopiedTextAs];
    [[NSUserDefaults standardUserDefaults] setObject:gistifyCopiedTextAsData forKey:kGistifyAsGlobalShortcut];
    
    [[NSUserDefaults standardUserDefaults] setObject:@".rb" forKey:@"format"];
    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"anonymous"];
    [[NSUserDefaults standardUserDefaults] setObject:@"public" forKey:@"visibility"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
    
    [_preferencesController openPreferences];
}

- (void)upgradeDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"anonymous"];
    [[NSUserDefaults standardUserDefaults] setObject:@"public" forKey:@"visibility"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

@end
