//
//  MenuBarController.m
//  Gistify
//
//  Created by Josh Symonds on 6/13/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "MenubarController.h"
#import "MASShortcut.h"
#import "Constants.h"
#import "Gist.h"
#import "StatusItemView.h"

@implementation MenubarController

@synthesize statusItemView = _statusItemView;

#pragma mark -

void *kGistifyShortcutContext = &kGistifyShortcutContext;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [NSBundle loadNibNamed:@"Menubar" owner:self];
        
        // Install status item into the menu bar
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:statusItem andStatusMenu:self.statusMenu];
        _statusItemView.image = [NSImage imageNamed:@"menubar-clipboard-idle"];
        _statusItemView.alternateImage = [NSImage imageNamed:@"menubar-clipboard-idle-highlighted"];
        
        // Observe keybinding changes to update the menu
        [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:kGistifyKeyPathShortcut
                                                                     options:NSKeyValueObservingOptionInitial
                                                                     context:kGistifyShortcutContext];
        [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:kGistifyAsKeyPathShortcut
                                                                     options:NSKeyValueObservingOptionInitial
                                                                     context:kGistifyShortcutContext];
        
        // Observe attempts to change the icon
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMenuImage:) name:@"setMenuIcon" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

- (void)menuDidClose:(NSMenu *)menu {
    [self.statusItemView setHighlighted:NO];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)obj change:(NSDictionary *)change context:(void *)ctx
{
    if (ctx == kGistifyShortcutContext) {
        [self rebindHotkeys];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:obj change:change context:ctx];
    }
}

- (void)rebindHotkeys {
    NSData *gistifyCopiedTextData = [[NSUserDefaults standardUserDefaults] objectForKey:kGistifyGlobalShortcut];
    MASShortcut *gistifyCopiedText = [MASShortcut shortcutWithData:gistifyCopiedTextData];
    if (gistifyCopiedText != nil) {
        [self.gistifyCopiedTextMenuItem setKeyEquivalent:gistifyCopiedText.keyCodeStringForKeyEquivalent];
        [self.gistifyCopiedTextMenuItem setKeyEquivalentModifierMask:gistifyCopiedText.modifierFlags];
    } else {
        [self.gistifyCopiedTextMenuItem setKeyEquivalent:@""];
        [self.gistifyCopiedTextMenuItem setKeyEquivalentModifierMask:0];
    }
    
    NSData *gistifyCopiedTextAsData = [[NSUserDefaults standardUserDefaults] objectForKey:kGistifyAsGlobalShortcut];
    MASShortcut *gistifyCopiedTextAs = [MASShortcut shortcutWithData:gistifyCopiedTextAsData];
    if (gistifyCopiedTextAs != nil) {
        [self.gistifyCopiedTextAsMenuItem setKeyEquivalent:gistifyCopiedTextAs.keyCodeStringForKeyEquivalent];
        [self.gistifyCopiedTextAsMenuItem setKeyEquivalentModifierMask:gistifyCopiedTextAs.modifierFlags];
    } else {
        [self.gistifyCopiedTextAsMenuItem setKeyEquivalent:@""];
        [self.gistifyCopiedTextAsMenuItem setKeyEquivalentModifierMask:0];
    }
}

- (void)setMenuImage:(NSNotification *)notification {
    NSString *image = [notification.userInfo objectForKey:@"image"];
    NSString *imageName = [NSString stringWithFormat:@"menubar-clipboard-%@", image];
    NSString *highlightedName = [NSString stringWithFormat:@"menubar-clipboard-%@-highlighted", image];

    [_statusItemView setImage:[NSImage imageNamed:imageName]];
    [_statusItemView setAlternateImage:[NSImage imageNamed:highlightedName]];    
}

- (IBAction)exitApplication:(id)sender {
    [NSApp terminate:nil];
}

- (IBAction)showPreferencesWindow:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPreferencesWindow" object:nil];
}

- (IBAction)gistifyCopiedTextMenuItem:(id)sender {
    [[Gist singleton] pasteDefaultClipboard];
}

- (IBAction)gistifyCopiedTextAsMenuItem:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openModal" object:nil];
}
@end
