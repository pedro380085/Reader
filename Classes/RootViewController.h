//
//  RootViewController.h
//  Reader
//
//  Created by Pedro on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocolos.h"

@class DetailViewController;

@interface RootViewController : UITableViewController <RootViewControllerDelegate, DownloadViewControllerDataSource> {
    DetailViewController *detailViewController;
    NSMutableArray *cache;
    
    BOOL tabelaModoEdicao;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSMutableArray *cache;

- (void) carregarCache;

@end
