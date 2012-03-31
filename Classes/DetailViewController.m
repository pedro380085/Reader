//
//  DetailViewController.m
//  Reader
//
//  Created by Pedro on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "PDFScrollView.h"
#import "PropagandaViewController.h"


@implementation DetailViewController

@synthesize popoverController, root, propagandaViewController, cacheButton, banner, urlAtual;

#pragma mark -
#pragma mark View lifecycle

- (void) viewDidLoad {
	// Autorizando o acesso da classe RootViewController aos objetos da DetailViewController
	root.detailViewController = self;
    
    //[BannerDownloadController sharedBannerDownloadController].delegate = self;
    
    // Criando e adicionando o controlador da propaganda
    propagandaViewController = [[PropagandaViewController alloc] initWithNibName:@"PropagandaViewController" bundle:nil];
    propagandaViewController.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appInativo) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAtivo) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    propagandaMostrada = NO;
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    // A animação, para funcionar, só pode ser chamada quando a view já tiver aparecido na tela
    [UIView transitionFromView:self.view toView:propagandaViewController.view duration:0.0 options:UIViewAnimationOptionTransitionNone completion:NULL];
}

#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
	[popoverController release];
	[root release];
    [propagandaViewController release];
    [cacheButton release];
    [banner release];
    [urlAtual release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark User Methods

- (void)appInativo {
    if (propagandaMostrada == NO) {
        [propagandaViewController invalidarTimer];
    }
}

- (void)appAtivo {
    if (propagandaMostrada == NO) {
        [propagandaViewController iniciarTimer];
    }
}


- (IBAction) baixarCache {
	// Atualiza o cache
	[[CacheDownloadController sharedCacheDownloadController] atualizarCache];
}

- (void) apresentarPdf:(NSString *)arquivo {
	
	if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }  

    
	/* Pega o número da linha selecionada, obtem o path do array, cria uma url e uma requisição e por fim carrega a requisição
		na webView. */
	/*
	// Create our PDFScrollView and add it to the view controller.
	PDFScrollView *sv = [[PDFScrollView alloc] initWithFrame:webView.bounds];
	[webView addSubview:sv];
	[sv release];
    */
    
    self.urlAtual = [NSURL fileURLWithPath:arquivo];
    [webView loadRequest:[NSURLRequest requestWithURL:urlAtual]];
}

- (void)propagandaApresentada {
    [UIView transitionFromView:propagandaViewController.view toView:self.view duration:1.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    propagandaMostrada = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)lerPdfEmOutroApp {
    if (urlAtual != nil) {
        UIDocumentInteractionController *docController = [[UIDocumentInteractionController interactionControllerWithURL:urlAtual] retain];
        docController.delegate = self;
        [docController presentOpenInMenuFromBarButtonItem:pdfOutroApp animated:YES];
    } else {
        [self infoLerPdfEmOutroApp];
    }
}

- (IBAction) infoModoEdicao {
	// Informa usuário sobre como modificar as células da tabela
    UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Sobre" 
						  message: @"Aplicativo para leitura das revistas dos Arquivos Brasileiros de Oftamologia (ABO).\n\nDesenvolvedor: Pedro P. M. Góes\n\nVersão atual: 1.2\nRelease: Novembro/2011\n"
						  delegate:self 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction) infoLerPdfEmOutroApp {
	// Informa usuário sobre como ler o pdf em outro app
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Externo" 
						  message: @"Caso queira ler alguma edição em outro aplicativo, selecione o documento desejado na tabela."
						  delegate:self 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Split View Controller support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Arquivos";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

#pragma mark -
#pragma mark Document Interaction Controller Delegate

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    [controller release];
}



@end
