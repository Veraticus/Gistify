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

@synthesize statusMenu, statusItem, generalPreferencesViewController, aboutPreferencesViewController, accountPreferencesViewController, preferencesWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)awakeFromNib {
    // First-time setup
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kGistifyGlobalShortcut]) {
        [self assignDefaults];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"anonymous"]) {
        [self upgradeDefaults];
    }
    
    // Register global shortcuts
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kGistifyGlobalShortcut handler:^{
        if (self.generalPreferencesViewController == nil || self.generalPreferencesViewController.gistifyCopiedTextView.recording != YES) {
            [[Paste singleton] sendToService];
        }
    }];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kGistifyAsGlobalShortcut handler:^{
        if (self.generalPreferencesViewController == nil || self.generalPreferencesViewController.gistifyCopiedTextAsView.recording != YES) {
            [[Paste singleton] openModal];
        }
    }];
    
    // Observe keybinding changes to update the menu
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:kGistifyKeyPathShortcut
                                                                 options:NSKeyValueObservingOptionInitial
                                                                 context:kGistifyShortcutContext];
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:kGistifyAsKeyPathShortcut
                                                                 options:NSKeyValueObservingOptionInitial
                                                                 context:kGistifyShortcutContext];
    
    // Set up the menu with shortcut keys
    [self rebindMenuHotkeys];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [self setMenuImage: @"idle"];
}

- (void)assignDefaults {
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    [launchController setLaunchAtLogin:YES];
    
    MASShortcut *gistifyCopiedText = [MASShortcut shortcutWithKeyCode:9 modifierFlags:NSShiftKeyMask|NSCommandKeyMask];
    NSData *gistifyCopiedTextData = [NSKeyedArchiver archivedDataWithRootObject:gistifyCopiedText];
    [[NSUserDefaults standardUserDefaults] setObject:gistifyCopiedTextData forKey:kGistifyGlobalShortcut];
    
    MASShortcut *gistifyCopiedTextAs = [MASShortcut shortcutWithKeyCode:9 modifierFlags:NSControlKeyMask|NSCommandKeyMask];
    NSData *gistifyCopiedTextAsData = [NSKeyedArchiver archivedDataWithRootObject:gistifyCopiedTextAs];
    [[NSUserDefaults standardUserDefaults] setObject:gistifyCopiedTextAsData forKey:kGistifyAsGlobalShortcut];
    
    [[NSUserDefaults standardUserDefaults] setObject:@".rb" forKey:@"format"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Gist" forKey:@"service"];
    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"anonymous"];
    [[NSUserDefaults standardUserDefaults] setObject:@"public" forKey:@"visibility"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
    
    [self showPreferencesWindow:nil];
}

- (void)upgradeDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"anonymous"];
    [[NSUserDefaults standardUserDefaults] setObject:@"public" forKey:@"visibility"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
}

- (void)rebindMenuHotkeys {
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

- (void)setMenuImage:(NSString *) image {
    NSString *imageName = [NSString stringWithFormat:@"menubar-clipboard-%@", image];
    NSString *highlightedName = [NSString stringWithFormat:@"menubar-clipboard-%@-highlighted", image];
    
    [statusItem setImage:[NSImage imageNamed:imageName]];
    [statusItem setAlternateImage:[NSImage imageNamed:highlightedName]];
    [statusItem setHighlightMode:YES];

}

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

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (IBAction)exitApplication:(id)sender {
    [NSApp terminate:nil];
}

- (IBAction)showPreferencesWindow:(id)sender {
    if (self.preferencesWindowController == nil)
    {
        self.generalPreferencesViewController = [[GeneralPreferencesViewController alloc] initWithNibName:@"GeneralPreferencesViewController" bundle:nil];
        self.accountPreferencesViewController = [[AccountPreferencesViewController alloc] initWithNibName:@"AccountPreferencesViewController" bundle:nil];
        self.aboutPreferencesViewController = [[AboutPreferencesViewController alloc] initWithNibName:@"AboutPreferencesViewController" bundle:nil];
        NSArray *controllers = [[NSArray alloc] initWithObjects:self.generalPreferencesViewController, self.accountPreferencesViewController, [NSNull null], self.aboutPreferencesViewController, nil];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        self.preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    
    [[NSApp mainWindow] close];
    
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
