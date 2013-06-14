//
//  ShortcutsController.h
//  Gistify
//
//  Created by Josh Symonds on 6/13/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MASShortcut;

@interface ShortcutsController : NSObject {
@private
    BOOL _isGistifyShorcutActive;
    BOOL _isGistifyAsShorcutActive;
}

@property (nonatomic) BOOL isGistifyShortcutActive;
@property (nonatomic) BOOL isGistifyAsShortcutActive;

-(void) enableGistifyShortcut;
-(void) disableGistifyShortcut;
-(void) enableGistifyAsShortcut;
-(void) disableGistifyAsShortcut;
-(void) enableShortcuts;
-(void) disableShortcuts;

@end
