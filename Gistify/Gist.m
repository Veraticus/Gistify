//
//  Gist.m
//  PasteAway
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "Gist.h"

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
    NSDictionary *params = @{@"public": @YES, @"files": @{@"test1.txt": @{@"content": pasting}}};
    NSLog(@"Params: %@", params);
    
    [[Paste singleton] receiveFromService:@"https://gist.github.com/5596517"];
    
    [self postPath:@"/gists" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[Paste singleton] receiveFromService:[responseObject objectForKey:@"html_url"]];
        NSLog(@"Returned data: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Horrible failure: %@", error);
    }];
}

@end
