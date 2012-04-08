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
#import "PropagandaViewController.h"

@class RootViewController;
@class PropagandaViewController;
 
@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIDocumentInteractionControllerDelegate, UIActionSheetDelegate, PropagandaViewControllerDelegate> {
    
    IBOutlet UIToolbar * toolbar;
	IBOutlet UIBarButtonItem * cacheButton;
    IBOutlet UIBarButtonItem * pdfOutroApp;
    IBOutlet UIBarButtonItem * actionButton;
    IBOutlet UIImageView * banner;
	IBOutlet UIWebView * webView;
}

@property (nonatomic) UIPopoverController *popoverController;
@property (nonatomic) DetailViewController *detailViewController;
@property (nonatomic) NSURL *urlAtual;
@property (nonatomic) UIBarButtonItem * cacheButton;
@property (nonatomic) UIImageView * banner;

- (IBAction)baixarCache;
- (void)apresentarPdf:(NSString *)arquivo;
- (IBAction)lerPdfEmOutroApp;
- (IBAction)infoLerPdfEmOutroApp;
- (IBAction)mostrarActionSheet:(id)sender;

@end
