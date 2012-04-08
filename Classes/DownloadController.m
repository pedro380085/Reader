//
//  DownloadController.m
//  Reader
//
//  Created by Pedro Góes on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadController.h"


@implementation DownloadController

@synthesize fila;
@synthesize dadosRecebidos;
@synthesize delegate;

// Cria um Singleton para a classe
SYNTHESIZE_SINGLETON_FOR_CLASS(DownloadController);

#pragma mark -
#pragma mark Memory management

- (id) init {
    
    fila = [NSMutableArray arrayWithCapacity:1];  
    
    return self;
}


#pragma mark -
#pragma mark User Methods

/*
 
 ESTRUTURA DO DICIONARIO DOS DOWNLOADS EM ESPERA:
 
    DOWNLOAD_URL: Url completa do arquivo a ser baixado
    DOWNLOAD_ARQUIVO: Nome do arquivo a ser baixado
    DOWNLOAD_CELULA: Célula para o valor da tag informada
    DOWNLOAD_TAG: Célula para o valor da tag informada
    DOWNLOAD_CACHE: Informa se é cache ou não
 
 
 */

- (BOOL) adicionarURL:(NSString *)url salvandoComo:(NSString *)arquivo comPath:(NSIndexPath *)path comTamanho:(int)tamanho comCache:(BOOL)cache {
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    [dic setValue:url forKey:DOWNLOAD_URL];
    [dic setValue:arquivo forKey:DOWNLOAD_ARQUIVO];
    [dic setValue:path forKey:DOWNLOAD_PATH];
    [dic setValue:[NSNumber numberWithInt:tamanho] forKey:DOWNLOAD_TAMANHO];
    [dic setValue:[NSNumber numberWithBool:cache] forKey:DOWNLOAD_CACHE];
    
    [fila insertObject:dic atIndex:0];
    
    
    [self atualizarInterfaceComProgresso:0.0 comTexto:NSLocalizedString(@"Aguardando término do download", nil)  comPath:path];
    
    // Depois que a URL foi adicionada, podemos iniciar o download
    [self iniciarDownload];
    
    return YES;
}

- (void) iniciarDownload {
    // Checa se existe algum download sendo efetuado no momento
    if (baixando == YES) {
        return;
    }
    
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
			// Atualiza a flag informando que algum download está sendo efetuado e retém os dados
			baixando = YES;
			dadosRecebidos = [NSMutableData data];
            
            [self atualizarInterfaceComProgresso:0.0 comTexto:NSLocalizedString(@"Conexão iniciada", nil) comPath:nil];
		} else {
            // Atualiza interface
            CustomCell * celula = (CustomCell *)[delegate.tableView cellForRowAtIndexPath:[[fila lastObject] objectForKey:DOWNLOAD_PATH]];
            celula.porcentagemTexto.text = NSLocalizedString(@"Conexão falhou!", nil);
            [self performSelector:@selector(restaurarInterface) withObject:nil afterDelay:0.4];
        }
	} else {
        [self performSelector:@selector(carregarCache) withObject:nil afterDelay:ANIMACAO_PADRAO];
    }
}

- (void)cancelarDownload {
    
}

- (void)atualizarInterfaceComProgresso:(float)progresso comTexto:(NSString *)texto comPath:(NSIndexPath *)path {
    CustomCell * celula;
    if (path == nil) {
        celula = (CustomCell *)[delegate.tableView cellForRowAtIndexPath:[[fila lastObject] objectForKey:DOWNLOAD_PATH]];
    } else {
        celula = (CustomCell *)[delegate.tableView cellForRowAtIndexPath:path];
    }
    celula.porcentagemBarra.hidden = NO;
    celula.porcentagemBarra.progress = progresso;
    celula.porcentagemTexto.hidden = NO;
    celula.porcentagemTexto.text = texto;
    celula.destaques.hidden = YES;
    celula.estadoDownload = YES;
}

- (void)atualizarInterfaceComProgresso:(float)progresso comTexto:(NSString *)texto comCelula:(CustomCell *)celula {
    celula.porcentagemBarra.hidden = NO;
    celula.porcentagemBarra.progress = progresso;
    celula.porcentagemTexto.hidden = NO;
    celula.porcentagemTexto.text = texto;
    celula.destaques.hidden = YES;
    celula.estadoDownload = YES;
}

- (void)atualizarInterfaceParaTabelaComCelula:(CustomCell *)celula paraPath:(NSIndexPath *)path {
    for (int i=0; i<[fila count]; i++) {
        if ([path compare:[[fila objectAtIndex:i] objectForKey:DOWNLOAD_PATH]] == NSOrderedSame) {
            if (i+1 != [fila count]) {
                [self atualizarInterfaceComProgresso:0.0 comTexto:NSLocalizedString(@"Aguardando término do download", nil)  comCelula:celula];
            } else {
                [self atualizarInterfaceComProgresso:((float)[dadosRecebidos length] / (float)[[[fila lastObject] objectForKey:DOWNLOAD_TAMANHO] intValue])
                                            comTexto:[NSString stringWithFormat:@"%d %%", (int) (100 * (float)[dadosRecebidos length] / (float)[[[fila lastObject] objectForKey:DOWNLOAD_TAMANHO] intValue])]
                                             comCelula:celula];
            }
        }
    }
}

- (void)restaurarInterface {
    CustomCell * celula = (CustomCell *)[delegate.tableView cellForRowAtIndexPath:[[fila lastObject] objectForKey:DOWNLOAD_PATH]];
    celula.porcentagemBarra.hidden = YES;
    celula.porcentagemTexto.hidden = YES;
    celula.destaques.hidden = NO;
}

- (void)carregarCache {
    [delegate carregarCache];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED <= 40302

#pragma mark -
#pragma mark Connection Support 4.3

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [dadosRecebidos setLength:0];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
    // Adiciona os dados recebidos a variável
    [dadosRecebidos appendData:data];
    
    [self atualizarInterfaceComProgresso:((float)[dadosRecebidos length] / (float)[[[fila lastObject] objectForKey:DOWNLOAD_TAMANHO] intValue])
                                comTexto:[NSString stringWithFormat:@"%d %%", (int) (100 * (float)[dadosRecebidos length] / (float)[[[fila lastObject] objectForKey:DOWNLOAD_TAMANHO] intValue])]
                                comPath:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Libera os objetos
    [connection release];
    [dadosRecebidos release];
    
    // Atualiza interface
    CustomCell * celula = (CustomCell *)[delegate.tableView cellForRowAtIndexPath:[[fila lastObject] objectForKey:DOWNLOAD_PATH]];
    celula.porcentagemTexto.text = NSLocalizedString(@"Download falhou!", nil);
    [self performSelector:@selector(restaurarInterface) withObject:nil afterDelay:0.4];
    
    // Atualiza a flag pois o download falhou
	baixando = NO;
    
    // Inicia o próximo download
    [self iniciarDownload];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// Salvando array em arquivo
    NSString * caminho = [[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"]
                          stringByAppendingPathComponent:[[fila lastObject] objectForKey:DOWNLOAD_ARQUIVO]];
	[dadosRecebidos writeToFile:caminho atomically:YES];
	
    // Libera os objetos
    [connection release];
    [dadosRecebidos release];
    
    // Atualiza interface
    CustomCell * celula = (CustomCell *)[delegate.tableView cellForRowAtIndexPath:[[fila lastObject] objectForKey:DOWNLOAD_PATH]];
    celula.porcentagemTexto.text = NSLocalizedString(@"Download completo!", nil);
    [self performSelector:@selector(restaurarInterface) withObject:nil afterDelay:0.4];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Remove o download completado da fila
    [fila removeLastObject];
    
    // Atualiza a flag pois o download terminou
	baixando = NO;
    
    // Informa a célula que o download terminou
    celula.estadoDownload = NO;
    
    // Inicia o próximo download
    [self iniciarDownload];
}

#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000

#pragma mark -
#pragma mark Connection Support 5.0

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [dadosRecebidos setLength:0];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
    // Adiciona os dados recebidos a variável
    [dadosRecebidos appendData:data];
    
    [self atualizarInterfaceComProgresso:((float)[dadosRecebidos length] / (float)[[[fila lastObject] objectForKey:DOWNLOAD_TAMANHO] intValue])
                                comTexto:[NSString stringWithFormat:@"%d %%", (int) (100 * (float)[dadosRecebidos length] / (float)[[[fila lastObject] objectForKey:DOWNLOAD_TAMANHO] intValue])]
                                 comPath:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Libera os objetos
    
    // Atualiza interface
    CustomCell * celula = (CustomCell *)[delegate.tableView cellForRowAtIndexPath:[[fila lastObject] objectForKey:DOWNLOAD_PATH]];
    celula.porcentagemTexto.text = NSLocalizedString(@"Download falhou!", nil);
    [self performSelector:@selector(restaurarInterface) withObject:nil afterDelay:0.4];
    
    // Atualiza a flag pois o download falhou
	baixando = NO;
    
    // Inicia o próximo download
    [self iniciarDownload];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {	

	// Salvando array em arquivo
    NSString * caminho = [[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"]
                          stringByAppendingPathComponent:[[fila lastObject] objectForKey:DOWNLOAD_ARQUIVO]];
	[dadosRecebidos writeToFile:caminho atomically:YES];
	
    // Libera os objetos
    
    // Atualiza interface
    CustomCell * celula = (CustomCell *)[delegate.tableView cellForRowAtIndexPath:[[fila lastObject] objectForKey:DOWNLOAD_PATH]];
    celula.porcentagemTexto.text = NSLocalizedString(@"Download completo!", nil);
    [self restaurarInterface];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Remove o download completado da fila
    [fila removeLastObject];
    
    // Atualiza a flag pois o download terminou
	baixando = NO;
    
    // Informa a célula que o download terminou
    celula.estadoDownload = NO;
    
    // Inicia o próximo download
    [self iniciarDownload];
}

#endif



@end
