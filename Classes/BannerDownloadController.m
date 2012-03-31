//
//  BannerDownloadController.m
//  Reader
//
//  Created by Pedro Góes on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BannerDownloadController.h"

@implementation BannerDownloadController

@synthesize cache;
@synthesize delegate;

// Cria um Singleton para a classe
SYNTHESIZE_SINGLETON_FOR_CLASS(BannerDownloadController);

#pragma mark -
#pragma mark Memory management

- (id) init {
    [NSTimer scheduledTimerWithTimeInterval:BANNER_TEMPO target:self selector:@selector(atualizarBanner) userInfo:nil repeats:YES];
    
    [self carregarCache];
    
    return self;
}

- (void)dealloc {
    [cache release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark User Methods

- (void)carregarCache {
    numMaxAparicoes = 0;
    
	NSString * docsDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"];
    cache = [[NSMutableArray alloc] initWithContentsOfFile:[docsDir stringByAppendingPathComponent: CACHE_BANNER_PLIST]];
    
    for (int i=0; i<[cache count]; i++) {
        numMaxAparicoes += [[[cache objectAtIndex:i] objectForKey:CACHE_VALOR] integerValue];
    }
}

- (void)atualizarBanner {
    
    if ([cache count] != 0) {
        int aleatorio;
        
        do {
            aleatorio = arc4random() % [cache count];
        } while ([[cache objectAtIndex:aleatorio] objectForKey:CACHE_CONTADOR] == [[cache objectAtIndex:aleatorio] objectForKey:CACHE_VALOR]);
        
        numAparicoes++;
        
        if (numAparicoes == numMaxAparicoes) {
            [self carregarCache];
        }
        
        [UIView animateWithDuration:ANIMACAO_PADRAO*5 animations:^{delegate.banner.image = [UIImage imageWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:[[cache objectAtIndex:aleatorio] objectForKey:CACHE_IMAGEM]]];}];
    }
}

- (void)novoCacheRecebido {
    [self carregarCache];
}

@end
