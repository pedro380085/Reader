//
//  ImageDownloadController.h
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
#import "DetailViewController.h"
#import "RootViewController.h"

@interface ImageDownloadController : NSObject {
    NSMutableArray * fila;
    NSMutableData * dadosRecebidos;
    
    id <DownloadViewControllerDataSource> delegate;
}

@property (retain) NSMutableArray * fila;
@property (retain) NSMutableData * dadosRecebidos;

@property (assign) id <DownloadViewControllerDataSource> delegate;


+ (ImageDownloadController *) sharedImageDownloadController;

- (BOOL) adicionarURL: (NSString *) url salvandoComo: (NSString *) dir;
- (void) atualizarImagens: (NSMutableArray *) info comDelegate: (id<DownloadViewControllerDataSource>) del;
- (void) iniciarDownload;

@end
