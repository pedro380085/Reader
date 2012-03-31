//
//  BannerDownloadController.h
//  Reader
//
//  Created by Pedro Góes on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constantes.h"
#import "Protocolos.h"
#import "SynthesizeSingleton.h"
#import "DetailViewController.h"

@interface BannerDownloadController : NSObject <DownloadViewControllerDataSource> {
    NSMutableArray * cache;
    NSInteger numAparicoes;
    NSInteger numMaxAparicoes;
    
    DetailViewController *delegate;
}

@property (retain) NSMutableArray *cache;
@property (assign) DetailViewController *delegate;

+ (BannerDownloadController *) sharedBannerDownloadController;

- (void)carregarCache;

@end
