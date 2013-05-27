//
//  Paste.m
//  Gistify
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "Paste.h"

@implementation Paste

@synthesize modalWindowController, extension, anonymous;

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

- (NSString *)retrieveAnonymous {
    NSString *anon;
    
    if (self.anonymous == nil) {
        anon = [[NSUserDefaults standardUserDefaults] objectForKey:@"anonymous"];
    } else {
        anon = self.anonymous;
        self.anonymous = nil;
    }
    
    NSLog(@"Anonymous? %@", anon);
    
    return anon;
}


- (void)sendToService {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *objects = [pasteboard readObjectsForClasses:@[NSString.class, NSAttributedString.class] options:nil];
    
    if (objects != nil && objects.count != 0) {
        NSString *pasting = [objects objectAtIndex:0];
        
        NSString *serviceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"service"];
        
        AppDelegate *app = (AppDelegate *)[NSApp delegate];
        [app setMenuImage:@"transmitting"];
        
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
    
    AppDelegate *app = (AppDelegate *)[NSApp delegate];
    [app setMenuImage:@"complete"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        [app setMenuImage:@"idle"];
    });
}

@end
