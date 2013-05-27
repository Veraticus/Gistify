//
//  Paste.h
//  Gistify
//
//  Created by Josh Symonds on 5/16/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Gist.h"
#import "ModalWindowController.h"

@interface Paste : NSObject

@property (nonatomic, retain) NSWindowController *modalWindowController;
@property (nonatomic, retain) NSString *extension;
@property (nonatomic, retain) NSString *anonymous;

+(Paste *)singleton;
-(NSString *)retrieveExtension;
-(NSString *)retrieveAnonymous;
-(void)openModal;
-(void)sendToService;
-(void)receiveFromService:(NSString *)returnedString;

@end
