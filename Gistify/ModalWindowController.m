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

-(IBAction)closeWindow:(id)sender {
    [self.window close];
}

-(IBAction)performPaste:(id)sender {
    NSLog(@"invoked!");
    [self.window close];
    [[Paste singleton] setExtension:self.pasteFormat.stringValue];
    [[Paste singleton] sendToService];
}

@end
