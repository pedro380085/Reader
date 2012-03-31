//
//  ImageDownloadController.m
//  Reader
//
//  Created by Pedro Góes on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageDownloadController.h"

@implementation ImageDownloadController

@synthesize fila;
@synthesize dadosRecebidos;
@synthesize delegate;

// Cria um Singleton para a classe
SYNTHESIZE_SINGLETON_FOR_CLASS(ImageDownloadController);

#pragma mark -
#pragma mark Memory management

- (id) init {
    fila = [[NSMutableArray arrayWithCapacity:1] retain];  
    
    return self;
}

- (void) dealloc {
    [fila release];
    [dadosRecebidos release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark User Methods

/*
 
 ESTRUTURA DO DICIONARIO DOS DOWNLOADS EM ESPERA:
 
 DOWNLOAD_URL: Url completa do arquivo a ser baixado
 DOWNLOAD_ARQUIVO: Nome do arquivo a ser baixado
 DOWNLOAD_TAG: Valor inteiro pré-definido no arquivo cache
 DOWNLOAD_CACHE: Informa se é cache ou não
 
 
 */

- (BOOL) adicionarURL: (NSString *) url salvandoComo: (NSString *) arquivo {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [dic setValue:url forKey:DOWNLOAD_URL];
    [dic setValue:arquivo forKey:DOWNLOAD_ARQUIVO];
    
    [fila addObject:dic];
    
    [dic release];
    
    return YES;
}

- (void) atualizarImagens: (NSMutableArray *) info comDelegate: (id<DownloadViewControllerDataSource>) del {
    
    // Pega todas as imagens dentro dos vetores e coloca na fila de download
    for (int i=0; i<[info count]; i++) {
        for (int j=0; j<[[info objectAtIndex:i] count]; j++) {
            NSString * s = [[[info objectAtIndex:i] objectAtIndex:j] objectForKey:CACHE_IMAGEM];
            [self adicionarURL: [URL_ARQUIVO stringByAppendingFormat: s, nil] salvandoComo: s];
        }  
    }
    
    // Atribui o delegate
    self.delegate = del;
    
    // Depois que todas as URL foram adicionadas, podemos iniciar o download
    [self iniciarDownload];
}

- (void) iniciarDownload {     
    // Verifica se há algum arquivo para ser baixado
	if ([fila count] > 0) {
		
        // Obtém o ultimo objeto adicionado a lista (pilha)
        NSString * url = [[fila lastObject] objectForKey:DOWNLOAD_URL];
		
		// Criando a requisição
		NSURLRequest * theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
													 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:20.0];
		
		// Cria a conexão a partir da requisição e passa a carregar os dados
		NSURLConnection * theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
		if (theConnection) {
			dadosRecebidos = [[NSMutableData data] retain];		
        }
		
	} else {
        [delegate novoCacheRecebido];
    }
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
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
    // Libera os objetos
    [connection release];
    [dadosRecebidos release];
    
    // Inicia o próximo download, no caso, ele mesmo
    [self iniciarDownload];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
	// Salvando array em arquivo
    NSString * caminho = [[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"]
                          stringByAppendingPathComponent:[[fila lastObject] objectForKey:DOWNLOAD_ARQUIVO]];
	[dadosRecebidos writeToFile:caminho atomically:YES];
	
    // Libera os objetos
    [connection release];
    [dadosRecebidos release];
        
    // Remove o download completado da fila
    [fila removeLastObject];
    
    // Inicia o próximo download
    [self iniciarDownload];
}



@end
