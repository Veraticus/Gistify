//
//  ModalViewController.h
//  Gistify
//
//  Created by Josh Symonds on 5/17/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Paste.h"

@interface ModalWindowController : NSWindowController

@property (assign) IBOutlet NSTextField *pasteFormat;

-(IBAction)closeWindow:(id)sender;
-(IBAction)performPaste:(id)sender;

@end
