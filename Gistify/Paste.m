//
//  Paste.m
//  Gistify
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "Paste.h"

@implementation Paste

+(Paste *)singleton {
    static dispatch_once_t pred;
    static Paste *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[Paste alloc] init];
    });
    return shared;
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
        NSLog(@"Could not find anything appropriate to copy on the clipboard: %@", objects);
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
