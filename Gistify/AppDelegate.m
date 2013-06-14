//
//  AppDelegate.m
//  PasteAway
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "AppDelegate.h"
#import "MenubarController.h"
#import "PreferencesController.h"
#import "ShortcutsController.h"
#import "LaunchAtLoginController.h"
#import "Constants.h"
#import "Paste.h"

@implementation AppDelegate

@synthesize preferencesController = _preferencesController;
@synthesize shortcutsController = _shortcutsController;
@synthesize menubarController = _menubarController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // First-time setup
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kGistifyGlobalShortcut]) {
        [self assignDefaults];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"anonymous"]) {
        [self upgradeDefaults];
    }

    // Create preferences pane
    _preferencesController = [[PreferencesController alloc] init];
    
    // Setup shortcuts
    _shortcutsController = [[ShortcutsController alloc] init];
    
    // Setup menu
    _menubarController = [[MenubarController alloc] init];
    
    // Register for notifications
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)assignDefaults {
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    [launchController setLaunchAtLogin:YES];
    
    MASShortcut *gistifyCopiedText = [MASShortcut shortcutWithKeyCode:9 modifierFlags:NSShiftKeyMask|NSCommandKeyMask];
    NSData *gistifyCopiedTextData = [NSKeyedArchiver archivedDataWithRootObject:gistifyCopiedText];
    [[NSUserDefaults standardUserDefaults] setObject:gistifyCopiedTextData forKey:kGistifyGlobalShortcut];
    
    MASShortcut *gistifyCopiedTextAs = [MASShortcut shortcutWithKeyCode:9 modifierFlags:NSControlKeyMask|NSCommandKeyMask];
    NSData *gistifyCopiedTextAsData = [NSKeyedArchiver archivedDataWithRootObject:gistifyCopiedTextAs];
    [[NSUserDefaults standardUserDefaults] setObject:gistifyCopiedTextAsData forKey:kGistifyAsGlobalShortcut];
    
    [[NSUserDefaults standardUserDefaults] setObject:@".rb" forKey:@"format"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Gist" forKey:@"service"];
    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"anonymous"];
    [[NSUserDefaults standardUserDefaults] setObject:@"public" forKey:@"visibility"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
    
    [self showPreferencesWindow:nil];
}

- (void)upgradeDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"anonymous"];
    [[NSUserDefaults standardUserDefaults] setObject:@"public" forKey:@"visibility"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (IBAction)exitApplication:(id)sender {
    [NSApp terminate:nil];
}

- (IBAction)showPreferencesWindow:(id)sender {
    [_preferencesController openPreferences];
}

- (IBAction)gistifyCopiedTextMenuItem:(id)sender {
    [[Paste singleton] sendToService];
}

- (IBAction)gistifyCopiedTextAsMenuItem:(id)sender {
    [[Paste singleton] openModal];
}

@end
