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
    
    NSDictionary *params = @{@"public": @YES, @"files": @{fileName: @{@"content": pasting}}};
    NSLog(@"Params: %@", params);
    
    [self postPath:@"/gists" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[Paste singleton] receiveFromService:[responseObject objectForKey:@"html_url"]];
        NSLog(@"Returned data: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Horrible failure: %@", error);
    }];
}

@end
