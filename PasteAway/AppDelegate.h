//
//  AppDelegate.h
//  PasteAway
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GeneralPreferencesViewController.h"
#import "MASShortcut.h"
#import "MASShortcutView+UserDefaults.h"
#import "MASShortcut+UserDefaults.h"
#import "MASShortcut+Monitoring.h"
#import "MASPreferencesWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, retain) MASPreferencesWindowController *preferencesWindowController;

- (IBAction)exitApplication:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;

@end
