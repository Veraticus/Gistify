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
    
    [self.defaultFormatTextField setStringValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"format"]];
    
    self.gistifyCopiedTextView.associatedUserDefaultsKey = kGistifyGlobalShortcut;
    self.gistifyCopiedTextAsView.associatedUserDefaultsKey = kGistifyAsGlobalShortcut;
}

- (void)controlTextDidChange:(NSNotification *)notification {
    [[NSUserDefaults standardUserDefaults] setValue:self.defaultFormatTextField.stringValue forKey:@"format"];
}

- (IBAction)changeVisibility:(id)sender {
    if ([self.defaultVisibility.titleOfSelectedItem isEqualToString:@"Secret"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"secret" forKey:@"visibility"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@"public" forKey:@"visibility"];
    }
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


@end
