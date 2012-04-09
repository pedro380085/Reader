//
//  DetailViewController.m
//  Reader
//
//  Created by Pedro on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "PropagandaViewController.h"


@implementation DetailViewController

@synthesize popoverController, cacheButton, banner;
@synthesize detailViewController = _detailViewController;
@synthesize urlAtual = _urlAtual;

#pragma mark -
#pragma mark View lifecycle

- (void) viewDidLoad {
    cacheButton.title = NSLocalizedString(@"Atualizar dados", nil);
    actionButton.title = NSLocalizedString(@"Ler com outro app", nil);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(mostrarActionSheet:)];
        self.navigationItem.rightBarButtonItem = actionButton;
        
        [webView loadRequest:[NSURLRequest requestWithURL:_urlAtual]];
    }
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
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


#pragma mark -
#pragma mark User Methods

- (void)propagandaApresentada:(PropagandaViewController *)pvc {
    [UIView transitionFromView:pvc.view toView:self.parentViewController.view duration:ANIMACAO_PADRAO*1.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
}

- (IBAction)baixarCache {
	// Atualiza o cache
	[[CacheDownloadController sharedCacheDownloadController] atualizarCache];
}

- (void)apresentarPdf:(NSString *)arquivo {
	
	if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }  
    
    _urlAtual = [NSURL fileURLWithPath:arquivo];
    [webView loadRequest:[NSURLRequest requestWithURL:_urlAtual]];
}

- (IBAction)lerPdfEmOutroApp {
    if (_urlAtual != nil) {
        docController = [UIDocumentInteractionController interactionControllerWithURL:_urlAtual];
        docController.delegate = self;
        [docController presentOpenInMenuFromBarButtonItem:actionButton animated:YES];
    } else {
        [self infoLerPdfEmOutroApp];
    }
}

- (IBAction)infoLerPdfEmOutroApp {
	// Informa usuário sobre como ler o pdf em outro app
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:NSLocalizedString(@"Externo", nil)
						  message: NSLocalizedString(@"Externo Mensagem", @"Caso queira ler alguma edição em outro aplicativo, selecione o documento desejado na tabela.")
						  delegate:self 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
}

- (IBAction)mostrarActionSheet:(id)sender {
    // Mostra popover para o botão

    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Ações", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"Ler com outro app", nil), nil];
    [action showFromBarButtonItem:actionButton animated:YES];
}

#pragma mark -
#pragma mark Split View Controller support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = NSLocalizedString(@"Arquivos", nil);
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    self.popoverController = nil;
}

#pragma mark -
#pragma mark Document Interaction Controller Delegate

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
}

#pragma mark -
#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performSelector:@selector(lerPdfEmOutroApp) withObject:self afterDelay:2.0];
        //[self lerPdfEmOutroApp];
    }
}



@end
