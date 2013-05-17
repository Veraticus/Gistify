//
//  AppDelegate.m
//  PasteAway
//
//  Created by Josh Symonds on 5/15/13.
//  Copyright (c) 2013 Josh Symonds. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

void *kGistifyShortcutContext = &kGistifyShortcutContext;

@synthesize window, statusMenu, statusItem, preferencesWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

- (void)awakeFromNib {
    // First-time setup
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kGistifyGlobalShortcut]) {
        LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
        [launchController setLaunchAtLogin:YES];
        
        MASShortcut *gistifyCopiedText = [MASShortcut shortcutWithKeyCode:9 modifierFlags:NSShiftKeyMask|NSCommandKeyMask];
        NSData *gistifyCopiedTextData = [NSKeyedArchiver archivedDataWithRootObject:gistifyCopiedText];
        [[NSUserDefaults standardUserDefaults] setObject:gistifyCopiedTextData forKey:kGistifyGlobalShortcut];
        
        MASShortcut *gistifyCopiedTextAs = [MASShortcut shortcutWithKeyCode:9 modifierFlags:NSControlKeyMask|NSCommandKeyMask];
        NSData *gistifyCopiedTextAsData = [NSKeyedArchiver archivedDataWithRootObject:gistifyCopiedTextAs];
        [[NSUserDefaults standardUserDefaults] setObject:gistifyCopiedTextAsData forKey:kGistifyAsGlobalShortcut];
        
        [self showPreferencesWindow:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Gist" forKey:@"service"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"firstTimeSetup"];
    }
    
    // Register global shortcuts
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kGistifyGlobalShortcut handler:^{
        [[Paste singleton] sendToService];
    }];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kGistifyAsGlobalShortcut handler:^{
        [[Paste singleton] openModal];
    }];
    
    // Observe keybinding changes to update the menu
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:kGistifyKeyPathShortcut
                                                                 options:NSKeyValueObservingOptionInitial
                                                                 context:kGistifyShortcutContext];
    
    // Set up the menu with shortcut keys
    [self rebindMenuHotkeys];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setImage:[NSImage imageNamed:@"clipboard"]];
    [statusItem setHighlightMode:YES];
}

- (void)rebindMenuHotkeys {
    NSData *gistifyCopiedTextData = [[NSUserDefaults standardUserDefaults] objectForKey:kGistifyGlobalShortcut];
    MASShortcut *gistifyCopiedText = [MASShortcut shortcutWithData:gistifyCopiedTextData];
    [self.gistifyCopiedTextMenuItem setKeyEquivalent:gistifyCopiedText.keyCodeStringForKeyEquivalent];
    [self.gistifyCopiedTextMenuItem setKeyEquivalentModifierMask:gistifyCopiedText.modifierFlags];
    
    NSData *gistifyCopiedTextAsData = [[NSUserDefaults standardUserDefaults] objectForKey:kGistifyAsGlobalShortcut];
    MASShortcut *gistifyCopiedTextAs = [MASShortcut shortcutWithData:gistifyCopiedTextAsData];
    [self.gistifyCopiedTextAsMenuItem setKeyEquivalent:gistifyCopiedTextAs.keyCodeStringForKeyEquivalent];
    [self.gistifyCopiedTextAsMenuItem setKeyEquivalentModifierMask:gistifyCopiedTextAs.modifierFlags];}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)obj
                        change:(NSDictionary *)change context:(void *)ctx
{
    if (ctx == kGistifyShortcutContext) {
        [self rebindMenuHotkeys];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:obj change:change context:ctx];
    }
}

- (IBAction)exitApplication:(id)sender {
    [NSApp terminate:nil];
}

- (IBAction)showPreferencesWindow:(id)sender {
    if (self.preferencesWindowController == nil)
    {
        NSViewController *generalViewController = [[GeneralPreferencesViewController alloc] initWithNibName:@"GeneralPreferencesViewController" bundle:nil];
        NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, nil];
        
        // To add a flexible space between General and Advanced preference panes insert [NSNull null]:
        //     NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, [NSNull null], advancedViewController, nil];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        self.preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    
    [self.preferencesWindowController showWindow:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)gistifyCopiedTextMenuItem:(id)sender {
    [[Paste singleton] sendToService];
}

- (IBAction)gistifyCopiedTextAsMenuItem:(id)sender {
    [[Paste singleton] openModal];
}

@end
