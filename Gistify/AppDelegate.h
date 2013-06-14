//
//  AppDelegate.h
//  PasteAway
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferencesController;
@class ShortcutsController;
@class MenubarController;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate> {
@private
    PreferencesController *_preferencesController;
    ShortcutsController *_shortcutsController;
    MenubarController *_menubarController;
}

@property (nonatomic, retain) PreferencesController *preferencesController;
@property (nonatomic, retain) ShortcutsController *shortcutsController;
@property (nonatomic, retain) MenubarController *menubarController;

- (void)assignDefaults;
- (void)upgradeDefaults;

@end
