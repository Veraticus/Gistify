//
//  ModalViewController.m
//  Gistify
//
//  Created by Josh Symonds on 5/17/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "ModalWindowController.h"

@implementation ModalWindowController

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
        [[Paste singleton] setVisibility:@"secret"];
    } else {
        [[Paste singleton] setVisibility:@"public"];
    }
}

-(IBAction)changeAnonymous:(id)sender {
    if ([self.anonymous.titleOfSelectedItem isEqualToString:@"Anonymous"]) {
        [[Paste singleton] setAnonymous:@"true"];
    } else {
        [[Paste singleton] setAnonymous:@"false"];
    }    
}

-(IBAction)performPaste:(id)sender {
    [self.window close];
    [[Paste singleton] setExtension:self.pasteFormat.stringValue];
    [[Paste singleton] sendToService];
}

@end
