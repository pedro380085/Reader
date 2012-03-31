//
//  DetailViewController.h
//  Reader
//
//  Created by Pedro on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constantes.h"
#import "Protocolos.h"
#import "DownloadController.h"
#import "CacheDownloadController.h"
#import "BannerDownloadController.h"
#import "PropagandaViewController.h"

@class RootViewController;
@class PropagandaViewController;
 
@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIDocumentInteractionControllerDelegate> {
    UIPopoverController * popoverController;
	RootViewController * root;
    PropagandaViewController * propagandaViewController;
    NSURL *urlAtual;
    
    IBOutlet UIToolbar * toolbar;
	IBOutlet UIBarButtonItem * cacheButton;
	IBOutlet UIBarButtonItem * ultimaButton;
    IBOutlet UIBarButtonItem * pdfOutroApp;
    IBOutlet UIImageView * banner;
	IBOutlet UIWebView * webView;
    
    BOOL propagandaMostrada;
}

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet RootViewController *root;
@property (nonatomic, retain) PropagandaViewController * propagandaViewController;
@property (nonatomic, retain) UIBarButtonItem *cacheButton;
@property (nonatomic, retain) UIImageView *banner;
@property (nonatomic, retain) NSURL *urlAtual;

- (IBAction) baixarCache;
- (void) apresentarPdf:(NSString *)arquivo;
- (void)propagandaApresentada;
- (IBAction)lerPdfEmOutroApp;
- (IBAction) infoModoEdicao;
- (IBAction) infoLerPdfEmOutroApp;

@end
