//
//  PreferencesController.m
//  Gistify
//
//  Created by Josh Symonds on 6/13/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "PreferencesController.h"
#import "MASPreferencesWindowController.h"
#import "GeneralPreferencesController.h"
#import "AboutPreferencesController.h"
#import "AccountPreferencesController.h"

@implementation PreferencesController

@synthesize preferencesWindowController = _preferencesWindowController;
@synthesize generalPreferencesController = _generalPreferencesController;
@synthesize aboutPreferencesController = _aboutPreferencesController;
@synthesize accountPreferencesController = _accountPreferencesController;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _generalPreferencesController = [[GeneralPreferencesController alloc] initWithNibName:@"GeneralPreferencesView" bundle:nil];
        _aboutPreferencesController = [[AboutPreferencesController alloc] initWithNibName:@"AboutPreferencesView" bundle:nil];
        _accountPreferencesController = [[AccountPreferencesController alloc] initWithNibName:@"AccountPreferencesView" bundle:nil];
        
        NSArray *controllers = [[NSArray alloc] initWithObjects:_generalPreferencesController, _accountPreferencesController, [NSNull null], _aboutPreferencesController, nil];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPreferences) name:@"showPreferencesWindow" object:nil];
    }
    return self;
}

- (void)openPreferences {
    ProcessSerialNumber psn = { 0, kCurrentProcess };
    TransformProcessType(&psn, kProcessTransformToForegroundApplication);
    [[NSApp mainWindow] close];
    
    [NSApp activateIgnoringOtherApps:YES];
    [_preferencesWindowController.window makeKeyAndOrderFront:self];
}


@end
