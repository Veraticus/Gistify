//
//  ModalViewController.m
//  Gistify
//
//  Created by Josh Symonds on 5/17/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "ModalController.h"
#import "Gist.h"

@implementation ModalController

-(id)initWithWindowNibName:(NSString *)nibName {
    self = [super initWithWindowNibName:nibName];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openModal) name:@"openModal" object:nil];
    }
    return self;
}

- (void) openModal {
    [[NSApp mainWindow] close];
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:self];
}

# pragma mark NSWindowDelegate

- (void) windowDidResignKey:(NSNotification *)notification {
    [self.window close];
}

- (void) windowDidResignMain:(NSNotification *)notification {
    [self.window close];
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"token"] == nil) {
        [self.anonymous selectItemWithTitle:@"Anonymous"];
        self.anonymous.enabled = NO;
    } else {
        self.anonymous.enabled = YES;
        if ([[defaults objectForKey:@"anonymous"] isEqualToString:@"true"]) {
            [self.anonymous selectItemWithTitle:@"Anonymous"];
        } else {
            [self.anonymous selectItemWithTitle:@"GitHub Account"];
        }
    }
    
    if ([[defaults objectForKey:@"visibility"] isEqualToString:@"public"]) {
        [self.visibility selectItemWithTitle:@"Public"];
    } else {
        [self.visibility selectItemWithTitle:@"Secret"];
    }
    
    [self.pasteFormat setStringValue:[defaults objectForKey:@"format"]];
}

-(IBAction)closeWindow:(id)sender {
    [self.window close];
}

-(IBAction)changeVisibility:(id)sender {
    if ([self.visibility.titleOfSelectedItem isEqualToString:@"Secret"]) {
        [[Gist singleton] setVisibilityOverride:@"secret"];
    } else {
        [[Gist singleton] setVisibilityOverride:@"public"];
    }
}

-(IBAction)changeAnonymous:(id)sender {
    if ([self.anonymous.titleOfSelectedItem isEqualToString:@"Anonymous"]) {
        [[Gist singleton] setAnonymousOverride:@"true"];
    } else {
        [[Gist singleton] setAnonymousOverride:@"false"];
    }    
}

-(IBAction)performPaste:(id)sender {
    [self.window close];
    [[Gist singleton] setFormatOverride:self.pasteFormat.stringValue];
    [[Gist singleton] pasteDefaultClipboard];
}

# pragma mark -

@end
