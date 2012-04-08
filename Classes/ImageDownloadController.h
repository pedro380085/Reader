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
    
    id <DownloadViewControllerDataSource> __unsafe_unretained delegate;
}

@property  NSMutableArray * fila;
@property  NSMutableData * dadosRecebidos;

@property (unsafe_unretained) id <DownloadViewControllerDataSource> delegate;


+ (ImageDownloadController *) sharedImageDownloadController;

- (BOOL) adicionarURL: (NSString *) url salvandoComo: (NSString *) dir;
- (void) atualizarImagens: (NSMutableArray *) info comDelegate: (id<DownloadViewControllerDataSource>) del;
- (void) iniciarDownload;

@end
