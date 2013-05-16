//
//  AppDelegate.m
//  PasteAway
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "AppDelegate.h"

NSString *const MASPreferenceKeyShortcut = @"MASDemoShortcut";
NSString *const MASPreferenceKeyShortcutEnabled = @"MASDemoShortcutEnabled";
NSString *const MASPreferenceKeyConstantShortcutEnabled = @"MASDemoConstantShortcutEnabled";

@implementation AppDelegate

@synthesize window, statusMenu, statusItem, preferencesWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"myFavorites"];
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
}

@end
