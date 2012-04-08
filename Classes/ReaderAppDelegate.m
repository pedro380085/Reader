//
//  ReaderAppDelegate.m
//  Reader
//
//  Created by Pedro on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReaderAppDelegate.h"


#import "RootViewController.h"
#import "DetailViewController.h"
#import "PropagandaViewController.h"

@implementation ReaderAppDelegate

@synthesize window, splitViewController, navigationController, rootViewController, detailViewController;
@synthesize propagandaViewController = _propagandaViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.window addSubview:navigationController.view];
        [self.window makeKeyAndVisible];
        
        _propagandaViewController = [[PropagandaViewController alloc] initWithNibName:@"PropagandaViewController_iPhone" bundle:nil];
        
        [UIView transitionFromView:navigationController.view toView:_propagandaViewController.view duration:0.0 options:UIViewAnimationOptionTransitionNone completion:NULL];
        
        _propagandaViewController.delegate = rootViewController;
    } else {
        [self.window addSubview:splitViewController.view];
        [self.window makeKeyAndVisible];
        
        _propagandaViewController = [[PropagandaViewController alloc] initWithNibName:@"PropagandaViewController" bundle:nil];
        
        [UIView transitionFromView:splitViewController.view toView:_propagandaViewController.view duration:0.0 options:UIViewAnimationOptionTransitionNone completion:NULL];
        
        _propagandaViewController.delegate = detailViewController;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appInativo) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAtivo) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(propagandaApresentada) name:PropagandaApresentadaNotification object:nil];
    
    propagandaMostrada = NO;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

#pragma mark -
#pragma mark User Methods

- (void)appInativo {
    if (propagandaMostrada == NO) {
        [_propagandaViewController invalidarTimer];
    }
}

- (void)appAtivo {
    if (propagandaMostrada == NO) {
        [_propagandaViewController iniciarTimer];
    }
}

- (void)propagandaApresentada {
    propagandaMostrada = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end

