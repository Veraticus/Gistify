//
//  MenuBarController.h
//  Gistify
//
//  Created by Josh Symonds on 6/13/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusItemView.h"

#define STATUS_ITEM_VIEW_WIDTH 24.0

#pragma mark -

@class StatusItemView;

@interface MenubarController : NSObject <NSMenuDelegate> {
@private
    StatusItemView *_statusItemView;
}

@property (nonatomic) BOOL hasActiveIcon;
@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, strong, readonly) StatusItemView *statusItemView;

@property (assign) IBOutlet NSMenuItem *gistifyCopiedTextMenuItem;
@property (assign) IBOutlet NSMenuItem *gistifyCopiedTextAsMenuItem;
@property (assign) IBOutlet NSMenu *statusMenu;

- (void)rebindHotkeys;

- (IBAction)exitApplication:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)gistifyCopiedTextMenuItem:(id)sender;
- (IBAction)gistifyCopiedTextAsMenuItem:(id)sender;

@end
