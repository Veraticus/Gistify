//
//  PreferencesController.h
//  Gistify
//
//  Created by Josh Symonds on 6/13/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MASPreferencesWindowController;
@class GeneralPreferencesController;
@class AboutPreferencesController;
@class AccountPreferencesController;

@interface PreferencesController : NSObject {
@private
    MASPreferencesWindowController *_preferencesWindowController;
    GeneralPreferencesController *_generalPreferencesController;
    AboutPreferencesController *_aboutPreferencesController;
    AccountPreferencesController *_accountPreferencesController;
}

@property (nonatomic, retain) MASPreferencesWindowController *preferencesWindowController;
@property (nonatomic, retain) GeneralPreferencesController *generalPreferencesController;
@property (nonatomic, retain) AboutPreferencesController *aboutPreferencesController;
@property (nonatomic, retain) AccountPreferencesController *accountPreferencesController;

-(void) openPreferences;

@end
