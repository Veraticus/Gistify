//
//  AboutPreferencesController.m
//  Gistify
//
//  Created by Josh Symonds on 5/20/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "AboutPreferencesController.h"

@interface AboutPreferencesController ()

@end

@implementation AboutPreferencesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"AboutPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameInfo];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"About", @"About the app");
}


@end
