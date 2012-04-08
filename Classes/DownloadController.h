//
//  DownloadController.h
//  Reader
//
//  Created by Pedro Góes on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constantes.h"
#import "Protocolos.h"
#import "SynthesizeSingleton.h"
#import "RootViewController.h"
#import "ImageDownloadController.h"
#import "CustomCell.h"

@class CustomCell;

@interface DownloadController : NSObject {
    NSMutableArray * fila;
    NSMutableData * dadosRecebidos;
    BOOL baixando;
    
    RootViewController *__weak delegate;
}

@property  NSMutableArray * fila;
@property  NSMutableData * dadosRecebidos;

@property (weak) RootViewController *delegate;


+ (DownloadController *) sharedDownloadController;

- (BOOL)adicionarURL:(NSString *)url salvandoComo:(NSString *)arquivo comPath:(NSIndexPath *)path comTamanho:(int)tamanho comCache:(BOOL)cache;
- (void)iniciarDownload;
- (void)cancelarDownload;
- (void)atualizarInterfaceComProgresso:(float)progresso comTexto:(NSString *)texto comPath:(NSIndexPath *)path;
- (void)atualizarInterfaceComProgresso:(float)progresso comTexto:(NSString *)texto comCelula:(CustomCell *)celula;
- (void)atualizarInterfaceParaTabelaComCelula:(CustomCell *)celula paraPath:(NSIndexPath *)path;
- (void)restaurarInterface;
- (void)carregarCache;

@end
