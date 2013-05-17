//
//  AppDelegate.m
//  PasteAway
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window, statusMenu, statusItem, preferencesWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // First-time setup
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"firstTimeSetup"]) {
        LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
        [launchController setLaunchAtLogin:YES];
        
        [self showPreferencesWindow:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Gist" forKey:@"service"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"firstTimeSetup"];
    }
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kPreferenceGlobalShortcut handler:^{
        [[Paste singleton] sendToService];
    }];

}

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setImage:[NSImage imageNamed:@"clipboard"]];
    [statusItem setHighlightMode:YES];
}

- (IBAction)exitApplication:(id)sender {
    [NSApp terminate:nil];
}

- (IBAction)showPreferencesWindow:(id)sender {
    if (self.preferencesWindowController == nil)
    {
        NSViewController *generalViewController = [[GeneralPreferencesViewController alloc] initWithNibName:@"GeneralPreferencesViewController" bundle:nil];
        NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, nil];
        
        // To add a flexible space between General and Advanced preference panes insert [NSNull null]:
        //     NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, [NSNull null], advancedViewController, nil];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        self.preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    
    [self.preferencesWindowController showWindow:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

@end
