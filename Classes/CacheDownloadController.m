//
//  CacheDownloadController.m
//  Reader
//
//  Created by Pedro Góes on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CacheDownloadController.h"
#import "Constantes.h"
#import "Protocolos.h"
#import "SynthesizeSingleton.h"

@implementation CacheDownloadController

@synthesize dadosRecebidos;
@synthesize cacheInfo;
@synthesize delegate;

// Cria um Singleton para a classe
SYNTHESIZE_SINGLETON_FOR_CLASS(CacheDownloadController);

#pragma mark -
#pragma mark Memory management

- (id) init {
    [self definirTipoCache:CACHE_PADRAO];
    
    return self;
}

- (void) dealloc {
    [dadosRecebidos release];
    [cacheInfo release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark User Methods


- (void) definirTipoCache: (NSString *)tipo {
    if (tipo == CACHE_PADRAO) {
        cacheInfo = [[NSDictionary dictionaryWithObjectsAndKeys:CACHE_PADRAO_URL, DOWNLOAD_URL, CACHE_PADRAO_ARQUIVO, DOWNLOAD_ARQUIVO, CACHE_PADRAO_PLIST, DOWNLOAD_PLIST_PADRAO, CACHE_BANNER_PLIST, DOWNLOAD_PLIST_BANNER, nil] retain];
    } 
}

/*
 
 ESTRUTURA DO CACHE
 
 Strings separadas pelo caracter ',' ordenadas da seguinte maneira:
 
 1. ID: Valor inteiro e único representando o download
 2. TÍTULO: Título da revista
 3. IMAGEM: Nome da imagem com sua terminação
 4. DESTAQUES: Breve descrição do conteúdo da revista
 5. ARQUIVO: Nome do arquivo com sua terminação
 6. TAMANHO:	Valor inteiro com o tamanho em bytes da revista
 
 */

- (void) atualizarCache {
    
    // Checa se existe algum download sendo efetuado no momento ou se o dicionário não foi inicializado corretamente
    if (baixando == YES || [cacheInfo count] != 4) {
        return;
    }
    
    // Criando a requisição
    NSURLRequest * theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[cacheInfo objectForKey:DOWNLOAD_URL]]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:20.0];
    
    // Cria a conexão a partir da requisição e passa a carregar os dados
    NSURLConnection * theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        // Atualiza a flag informando que algum download está sendo efetuado
        baixando = YES;
        dadosRecebidos = [[NSMutableData data] retain];
    }
    
}

- (void) verificarCache {
    
    NSString * caminho = [[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"]
                          stringByAppendingPathComponent:[cacheInfo objectForKey:DOWNLOAD_ARQUIVO]];
    
    NSString * arquivoCache = [NSString stringWithContentsOfFile:caminho encoding:NSISOLatin1StringEncoding error:nil];
    
    NSArray * listaArquivo = [arquivoCache componentsSeparatedByString:@"{"];
    
    // Verifica se foram geradas duas partes (cache padrão e banners)
    if ([listaArquivo count] == 2) {
        NSArray * listaArquivoPadrao = [[listaArquivo objectAtIndex:0] componentsSeparatedByString:@";"];
        NSArray * listaArquivoBanner = [[listaArquivo objectAtIndex:1] componentsSeparatedByString:@";"];
        
        // O resto correto é 1 pois quando separamos uma string em n pedaços, geramos n+1 pedaços novos
        if (([listaArquivoPadrao count] % 6 == 1) && ([listaArquivoBanner count] % 4 == 1)) {
            NSInteger numRevistas = ([listaArquivoPadrao count] - 1) / 6;
            NSInteger numBanners = ([listaArquivoBanner count] - 1) / 4;
            
            NSMutableArray * vetorPadrao = [[NSMutableArray alloc] initWithCapacity:numRevistas];
            NSMutableArray * vetorBanners = [[NSMutableArray alloc] initWithCapacity:numBanners];
            
            // Atribuimos os valores do array em um dicionário
            for (int i=0; i<numRevistas*6; i=i+6) {
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:6];
                
                [dic setValue:[NSNumber numberWithInteger:[[listaArquivoPadrao objectAtIndex:(i)] integerValue]] forKey:CACHE_ID];
                [dic setValue:[listaArquivoPadrao objectAtIndex:(i+1)] forKey:CACHE_TITULO];
                [dic setValue:[listaArquivoPadrao objectAtIndex:(i+2)] forKey:CACHE_IMAGEM];
                [dic setValue:[listaArquivoPadrao objectAtIndex:(i+3)] forKey:CACHE_DESTAQUES];
                [dic setValue:[listaArquivoPadrao objectAtIndex:(i+4)] forKey:CACHE_ARQUIVO];
                [dic setValue:[NSNumber numberWithInteger:[[listaArquivoPadrao objectAtIndex:(i+5)] integerValue]] forKey:CACHE_TAMANHO];
                
                [vetorPadrao addObject:dic];
                
                [dic release];
            }
            
            [vetorPadrao writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"]
                                stringByAppendingPathComponent:[cacheInfo objectForKey:DOWNLOAD_PLIST_PADRAO]] atomically:YES];
            
            // Atribuimos os valores do array em um dicionário
            for (int i=0; i<numBanners*4; i=i+4) {
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:4];
                
                [dic setValue:[NSNumber numberWithInteger:[[listaArquivoBanner objectAtIndex:(i)] integerValue]] forKey:CACHE_ID];
                [dic setValue:[listaArquivoBanner objectAtIndex:(i+1)] forKey:CACHE_NOME];
                [dic setValue:[listaArquivoBanner objectAtIndex:(i+2)] forKey:CACHE_IMAGEM];
                [dic setValue:[NSNumber numberWithInteger:[[listaArquivoBanner objectAtIndex:(i+3)] integerValue]] forKey:CACHE_VALOR];
                [dic setValue:[NSNumber numberWithInteger:0] forKey:CACHE_CONTADOR];
                
                [vetorBanners addObject:dic];
                
                [dic release];
            }
            
            [vetorBanners writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"]
                                stringByAppendingPathComponent:[cacheInfo objectForKey:DOWNLOAD_PLIST_BANNER]] atomically:YES];
            
            [[ImageDownloadController sharedImageDownloadController] atualizarImagens:[NSMutableArray arrayWithObjects:vetorPadrao, vetorBanners, nil] comDelegate:delegate];
            
            [vetorPadrao release];
            [vetorBanners release];
            
        } else {
            [self atualizarCache];
        }
    } else {
        [self atualizarCache];
    }
    
}

- (void)restaurarInterface {
    delegate.detailViewController.cacheButton.style = UIBarButtonItemStyleBordered;
    delegate.detailViewController.cacheButton.title = @"Atualizar cache";
}


#pragma mark -
#pragma mark Connection Support

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [dadosRecebidos setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
    // Adiciona os dados recebidos a variável
    [dadosRecebidos appendData:data];

    // Atualiza interface
    delegate.detailViewController.cacheButton.style = UIBarButtonItemStyleDone;
    delegate.detailViewController.cacheButton.title = @"Atualizando ...";
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Libera os objetos
    [connection release];
    [dadosRecebidos release];
    
    // Atualiza interface
    delegate.detailViewController.cacheButton.title = @"Atualização falhou!";
    [self performSelector:@selector(restaurarInterface) withObject:nil afterDelay:1.0];
    
    // Atualiza a flag pois o download falhou
	baixando = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{	
	// Salvando array em arquivo
    NSString * caminho = [[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"]
                          stringByAppendingPathComponent:[cacheInfo objectForKey:DOWNLOAD_ARQUIVO]];
	[dadosRecebidos writeToFile:caminho atomically:YES];
	
    // Libera os objetos
    [connection release];
    [dadosRecebidos release];
    
    // Atualiza interface
    delegate.detailViewController.cacheButton.title = @"Atualizado!";
    [self performSelector:@selector(restaurarInterface) withObject:nil afterDelay:1.0];
    
    // Verifica a integridade do cache
    [self verificarCache];
    
    // Atualiza a flag pois o download terminou
	baixando = NO;
}



@end
