//
//  Gist.m
//  Gistify
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "Gist.h"
#include <stdlib.h>

@implementation Gist

@synthesize formatOverride = _formatOverride;
@synthesize anonymousOverride = _anonymousOverride;
@synthesize visibilityOverride = _visibilityOverride;

+(Gist *)singleton {
    static dispatch_once_t pred;
    static Gist *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[Gist alloc] initWithBaseURL:[NSURL URLWithString:kGistURL]];
    });
    return shared;
}

#pragma mark AFHTTPClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self setParameterEncoding:AFJSONParameterEncoding];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

-(void)pasteDefaultClipboard {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *objects = [pasteboard readObjectsForClasses:@[NSString.class, NSAttributedString.class] options:nil];
    
    if (objects != nil && objects.count != 0) {
        NSString *pasting = [objects objectAtIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setMenuIcon" object:nil userInfo:@{@"image": @"transmitting"}];

        [self setToken];        
        NSMutableDictionary *params = [self params];
        [params setObject:@{[self randomFilename]: @{@"content": pasting}} forKey:@"files"];
                
        [self postPath:@"/gists" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self receive:[responseObject objectForKey:@"html_url"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:@"Gistify failed! Make sure you have text to Gistify on your clipboard."];
            [alert runModal];
        }];
    } else {
        [self nothingToPaste];
    }
}

-(void)authenticate {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    [self setAuthorizationHeaderWithUsername:username password:password];
    
    NSDictionary *params = @{@"scopes": @[@"gist"], @"note": @"Gistify", @"client_id": kGistifyAppClientId, @"client_secret": kGistifyAppClientSecret};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseLogin" object:nil userInfo:nil];
    
    [self postPath:@"/authorizations" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"token"] forKey:@"token"];
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"You have logged in successfully."];
        [alert runModal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unpauseLogin" object:nil userInfo:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Your username or password was incorrect."];
        [alert runModal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unpauseLogin" object:nil userInfo:nil];
    }];
}

-(void)receive:(NSString *)response {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard writeObjects:@[response]];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Gist Created";
    notification.informativeText = @"The URL has been added to your clipboard.";
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setMenuIcon" object:nil userInfo:@{@"image": @"complete"}];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setMenuIcon" object:nil userInfo:@{@"image": @"idle"}];
    });
}

#pragma mark -
#pragma mark Helper Methods

-(void)nothingToPaste {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Nothing to Paste";
    notification.informativeText = @"Try copying something before you Gistify it.";
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(NSMutableDictionary *)params {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if ([self.visibility isEqualToString:@"public"]) {
        [params setObject:@YES forKey:@"public"];
    } else {
        [params setObject:@NO forKey:@"public"];
    }

    return params;
}

-(void)setToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if ([[self anonymous] isEqualToString:@"false"] && token != nil) {
        [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"token %@", token]];
    } else {
        [self setDefaultHeader:@"Authorization" value:nil];
    }

}

-(NSString *)randomFilename {
    int randomNumber = arc4random_uniform(1000000);
    NSString *fileName = [NSString stringWithFormat:@"gistify%i%@", randomNumber, self.format];
    return fileName;
}

-(NSString *)format {
    NSString *format;
    
    if (_formatOverride == nil) {
        format = [[NSUserDefaults standardUserDefaults] objectForKey:@"format"];
    } else {
        format = _formatOverride;
        _formatOverride = nil;
    }
    
    NSString *firstLetter = [format substringToIndex:1];
    if (![firstLetter isEqualToString:@"."]) {
        format = [NSString stringWithFormat:@".%@", format];
    }
    
    return format;
}

-(NSString *)anonymous {
    NSString *anonymous;
    
    if (_anonymousOverride == nil) {
        anonymous = [[NSUserDefaults standardUserDefaults] objectForKey:@"anonymous"];
    } else {
        anonymous = _anonymousOverride;
        _anonymousOverride = nil;
    }
    
    return anonymous;
}

-(NSString *)visibility {
    NSString *visibility;
    
    if (_visibilityOverride == nil) {
        visibility = [[NSUserDefaults standardUserDefaults] objectForKey:@"visibility"];
    } else {
        visibility = _visibilityOverride;
        _visibilityOverride = nil;
    }
    
    return visibility;   
}


@end
