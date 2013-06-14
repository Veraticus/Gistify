//
//  ShortcutsController.m
//  Gistify
//
//  Created by Josh Symonds on 6/13/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "ShortcutsController.h"
#import "Constants.h"
#import "Paste.h"
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
            if (_isGistifyAsShorcutActive) {
                [[Paste singleton] sendToService];
            }
        }];
        
        [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kGistifyAsGlobalShortcut handler:^{
            if (_isGistifyShorcutActive) {
                [[Paste singleton] openModal];
            }
        }];

    }
    return self;
}


@end
