//
//  GeneralPreferencesController.h
//  PasteAway
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASShortcut.h"
#import "MASShortcutView.h"
#import "MASShortcutView+UserDefaults.h"
#import "MASShortcut+UserDefaults.h"
#import "MASShortcut+Monitoring.h"
#import "MASPreferencesViewController.h"
#import "Constants.h"

@interface GeneralPreferencesController : NSViewController <MASPreferencesViewController>

@property (assign) IBOutlet MASShortcutView *gistifyCopiedTextView;
@property (assign) IBOutlet MASShortcutView *gistifyCopiedTextAsView;
@property (assign) IBOutlet NSTextField *defaultFormatTextField;
@property (assign) IBOutlet NSPopUpButton *defaultVisibility;

- (void)controlTextDidChange:(NSNotification *)notification;
- (IBAction)changeVisibility:(id)sender;

@end
