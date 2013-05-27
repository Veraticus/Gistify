//
//  Gist.m
//  PasteAway
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "Gist.h"
#include <stdlib.h>

@implementation Gist

+(Gist *)singleton {
    static dispatch_once_t pred;
    static Gist *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[Gist alloc] initWithBaseURL:[NSURL URLWithString:kGistURL]];
    });
    return shared;
}

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

-(void)paste:(NSString *)pasting {
    int randomNumber = arc4random_uniform(100000);
    NSString *extension = [[Paste singleton] retrieveExtension];
    NSString *fileName = [NSString stringWithFormat:@"gistify%i%@", randomNumber, extension];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@{fileName: @{@"content": pasting}} forKey:@"files"];
    
    if ([[[Paste singleton] retrieveVisibility] isEqualToString:@"public"]) {
        [params setObject:@YES forKey:@"public"];
    } else {
        [params setObject:@NO forKey:@"public"];
    }
        
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if ([[[Paste singleton] retrieveAnonymous] isEqualToString:@"false"] && token != nil) {
        [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"token %@", token]];
    } else {
        [self setDefaultHeader:@"Authorization" value:nil];
    }
    
    [self postPath:@"/gists" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[Paste singleton] receiveFromService:[responseObject objectForKey:@"html_url"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Gistify failed! Make sure you have text to Gistify on your clipboard."];
        [alert runModal];
    }];
}

-(void)authenticate {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    [self setAuthorizationHeaderWithUsername:username password:password];
    
    NSDictionary *params = @{@"scopes": @[@"gist"], @"note": @"Gistify", @"client_id": kGistifyAppClientId, @"client_secret": kGistifyAppClientSecret};
    
    [self postPath:@"/authorizations" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"token"] forKey:@"token"];
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"You have logged in successfully."];
        [alert runModal];
        
        AppDelegate *app = (AppDelegate *)[NSApp delegate];
        [app.accountPreferencesViewController setupLoginWindow];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Your username or password was incorrect."];
        [alert runModal];
    }];
}

@end
