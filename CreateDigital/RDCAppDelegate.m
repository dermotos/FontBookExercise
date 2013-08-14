//
//  RDCAppDelegate.m
//  CreateDigital
//
//  Created by Dermot on 13/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCFontBookViewController.h"
#import "RDCAppDelegate.h"
#import "IIViewDeckController.h"
#import "RDCSettingsViewController.h"

@implementation RDCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RDCFontBookViewController *fontBookController = [[RDCFontBookViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fontBookController];
    RDCSettingsViewController *backgroundViewController = [[RDCSettingsViewController alloc] initWithNibName:@"RDCSettingsViewController" bundle:nil];
    IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:navigationController topViewController:backgroundViewController];
    deckController.topSize = [[UIScreen mainScreen] bounds].size.height - backgroundViewController.view.frame.size.height;
    self.deckController = deckController;
    [self.window setRootViewController:deckController];
    [self.window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
   }

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
