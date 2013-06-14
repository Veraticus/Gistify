//
//  ShortcutsController.m
//  Gistify
//
//  Created by Josh Symonds on 6/13/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "ShortcutsController.h"
#import "Constants.h"
#import "Gist.h"
#import "MASShortcut.h"
#import "MASShortcutView+UserDefaults.h"
#import "MASShortcut+UserDefaults.h"
#import "MASShortcut+Monitoring.h"

@implementation ShortcutsController

@synthesize isGistifyShortcutActive = _isGistifyShorcutActive;
@synthesize isGistifyAsShortcutActive = _isGistifyAsShorcutActive;

- (id)init {
    self = [super init];
    if (self != nil)
    {
        _isGistifyShorcutActive = YES;
        _isGistifyAsShorcutActive = YES;
        
        // Register global shortcuts
        [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kGistifyGlobalShortcut handler:^{
            if (_isGistifyShorcutActive) {
                [[Gist singleton] pasteDefaultClipboard];
            }
        }];
        
        [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kGistifyAsGlobalShortcut handler:^{
            if (_isGistifyAsShorcutActive) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"openModal" object:nil];;
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableGistifyShortcut) name:@"enableGistifyShortcut" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableGistifyShortcut) name:@"disableGistifyShortcut" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableGistifyAsShortcut) name:@"enableGistifyAsShortcut" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableGistifyAsShortcut) name:@"disableGistifyAsShortcut" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableShortcuts) name:@"enableShortcuts" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableShortcuts) name:@"disableShortcuts" object:nil];

    }
    return self;
}

#pragma mark Shortcut Control

-(void) enableGistifyShortcut {
    _isGistifyShorcutActive = YES;
}

-(void) disableGistifyShortcut {
    _isGistifyShorcutActive = NO;
}

-(void) enableGistifyAsShortcut {
    _isGistifyAsShorcutActive = YES;
}

-(void) disableGistifyAsShortcut {
    _isGistifyAsShorcutActive = NO;
}

-(void) enableShortcuts {
    _isGistifyShorcutActive = YES;
    _isGistifyAsShorcutActive = YES;
}

-(void) disableShortcuts {
    _isGistifyShorcutActive = NO;
    _isGistifyAsShorcutActive = NO;
}

@end
