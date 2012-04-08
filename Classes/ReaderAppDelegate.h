//
//  ReaderAppDelegate.h
//  Reader
//
//  Created by Pedro on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RootViewController;
@class DetailViewController;
@class CustomCell;
@class PDFScrollView;
@class PropagandaViewController;

@interface ReaderAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    UINavigationController *navigationController;
    RootViewController *rootViewController;
    DetailViewController *detailViewController;
    
    BOOL propagandaMostrada;
}

@property (nonatomic) IBOutlet UIWindow *window;

@property (nonatomic) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic) IBOutlet UINavigationController *navigationController;
@property (nonatomic) IBOutlet RootViewController *rootViewController;
@property (nonatomic) IBOutlet DetailViewController *detailViewController;
@property (nonatomic) PropagandaViewController * propagandaViewController;

@end
