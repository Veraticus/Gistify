//
//  Gist.h
//  PasteAway
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Constants.h"
#import "Paste.h"

@interface Gist : AFHTTPClient

+(Gist *)singleton;
-(void)paste:(NSString *)pasting;

@end
