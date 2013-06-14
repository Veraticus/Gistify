//
//  GeneralPreferencesController.m
//  Gistify
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "GeneralPreferencesController.h"

@implementation GeneralPreferencesController

- (void)loadView {
    [super loadView];
    
    [self.defaultFormatTextField setStringValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"format"]];
    
    self.gistifyCopiedTextView.associatedUserDefaultsKey = kGistifyGlobalShortcut;
    self.gistifyCopiedTextAsView.associatedUserDefaultsKey = kGistifyAsGlobalShortcut;
    
    [self.gistifyCopiedTextView addObserver:self forKeyPath:@"recording"
                                    options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                                    context:nil];
    
    [self.gistifyCopiedTextAsView addObserver:self.gistifyCopiedTextAsView forKeyPath:@"recording"
                                      options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                                      context:nil];
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

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual:@"recording"]) {
        if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue] == YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"disableShortcuts" object:nil userInfo:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"enableShortcuts" object:nil userInfo:nil];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
