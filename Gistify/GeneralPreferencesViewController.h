//
//  GeneralPreferencesViewController.h
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

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (nonatomic, weak) IBOutlet MASShortcutView *gistifyCopiedTextView;
@property (nonatomic, weak) IBOutlet MASShortcutView *gistifyCopiedTextAsView;
@property (nonatomic, weak) IBOutlet NSPopUpButton *serviceSelector;

-(IBAction)setService:(id)sender;

@end
