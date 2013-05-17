//
//  GeneralPreferencesViewController.m
//  PasteAway
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "GeneralPreferencesViewController.h"

@implementation GeneralPreferencesViewController

- (void)loadView {
    [super loadView];

    self.shortcutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;    
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

- (IBAction)setService:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.serviceSelector.selectedItem.title forKey:@"service"];
}

@end
