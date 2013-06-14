//
//  Gist.h
//  Gistify
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Constants.h"

@interface Gist : AFHTTPClient {
@private
    NSString *_formatOverride;
    NSString *_anonymousOverride;
    NSString *_visibilityOverride;
}

@property (nonatomic, retain) NSString *formatOverride;
@property (nonatomic, retain) NSString *anonymousOverride;
@property (nonatomic, retain) NSString *visibilityOverride;

+(Gist *)singleton;
-(void)pasteDefaultClipboard;
-(void)authenticate;
-(void)receive:(NSString *)response;

-(void)nothingToPaste;

-(void)setToken;
-(NSMutableDictionary *)params;
-(NSString *)randomFilename;
-(NSString *)format;
-(NSString *)anonymous;
-(NSString *)visibility;

@end
