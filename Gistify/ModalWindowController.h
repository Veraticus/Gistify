//
//  ModalViewController.h
//  Gistify
//
//  Created by Josh Symonds on 5/17/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Paste.h"

@interface ModalWindowController : NSWindowController <NSWindowDelegate>

@property (assign) IBOutlet NSTextField *pasteFormat;
@property (assign) IBOutlet NSPopUpButton *visibility;
@property (assign) IBOutlet NSPopUpButton *anonymous;

-(IBAction)closeWindow:(id)sender;
-(IBAction)changeVisibility:(id)sender;
-(IBAction)changeAnonymous:(id)sender;
-(IBAction)performPaste:(id)sender;

@end
