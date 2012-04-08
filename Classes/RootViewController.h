//
//  RootViewController.h
//  Reader
//
//  Created by Pedro on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocolos.h"
#import "PropagandaViewController.h"

@class DetailViewController;
@class PropagandaViewController;

@interface RootViewController : UITableViewController <RootViewControllerDelegate, DownloadViewControllerDataSource, PropagandaViewControllerDelegate> {
    NSMutableArray *cache;
    
    BOOL tabelaModoEdicao;
}

@property (nonatomic) NSMutableArray *cache;
@property (nonatomic, strong) DetailViewController *detailViewController;

- (IBAction) sobre;
- (void) carregarCache;

@end
