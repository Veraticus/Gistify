//
//  Paste.h
//  Gistify
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gist.h"

@interface Paste : NSObject

+(Paste *)singleton;
-(void)sendToService;
-(void)receiveFromService:(NSString *)returnedString;

@end
