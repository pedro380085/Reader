//
//  CacheDownloadController.h
//  Reader
//
//  Created by Pedro Góes on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constantes.h"
#import "Protocolos.h"
#import "SynthesizeSingleton.h"
#import "ImageDownloadController.h"
#import "CustomCell.h"
#import "DetailViewController.h"
#import "RootViewController.h"

@class RootViewController;

@interface CacheDownloadController : NSObject {
    NSMutableData *dadosRecebidos;
    NSDictionary *cacheInfo;
    BOOL baixando;
    
    RootViewController *__weak delegate;
}

@property (nonatomic) NSMutableData *dadosRecebidos;
@property (nonatomic) NSDictionary *cacheInfo;

@property (weak) RootViewController *delegate;

+ (CacheDownloadController *) sharedCacheDownloadController;

- (void)definirTipoCache:(NSString *)tipo;
- (void)atualizarCache;
- (void)verificarCache;
- (void)carregarCache;

@end
