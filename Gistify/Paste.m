//
//  Paste.m
//  Gistify
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "Paste.h"

@implementation Paste

@synthesize modalWindowController, extension;

+(Paste *)singleton {
    static dispatch_once_t pred;
    static Paste *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[Paste alloc] init];
    });
    return shared;
}

- (void)openModal {
    if (self.modalWindowController == nil)
    {
        ModalWindowController *controller = [[ModalWindowController alloc] initWithWindowNibName:@"ModalWindowController"];
        self.modalWindowController = controller;
    }
    
    [[NSApp mainWindow] close];
    [NSApp activateIgnoringOtherApps:YES];
    [self.modalWindowController.window makeKeyAndOrderFront:self.modalWindowController];
}

- (NSString *)retrieveExtension {
    NSString *ext;
    
    if (self.extension == nil) {
        ext = [[NSUserDefaults standardUserDefaults] objectForKey:@"format"];
    } else {
        ext = self.extension;
        self.extension = nil;
    }
    
    NSString *firstLetter = [ext substringToIndex:1];
    if (![firstLetter isEqualToString:@"."]) {
        ext = [NSString stringWithFormat:@".%@", ext];
    }

    return ext;
}

- (void)sendToService {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *objects = [pasteboard readObjectsForClasses:@[NSString.class, NSAttributedString.class] options:nil];
    
    if (objects != nil && objects.count != 0) {
        NSString *pasting = [objects objectAtIndex:0];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *serviceName = [defaults objectForKey:@"service"];
        
        if ([serviceName isEqualToString:@"Gist"]) {
            [[Gist singleton] paste:pasting];
        }
    } else {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"Nothing to Paste";
        notification.informativeText = @"Try copying something before you Gistify it.";
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}

- (void)receiveFromService:(NSString *)returnedString {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard writeObjects:@[returnedString]];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Gist Created";
    notification.informativeText = @"The URL has been added to your clipboard.";
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

@end
