//
//  CustomCell.h
//  Reader
//
//  Created by Pedro on 22/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocolos.h"
#import "Constantes.h"
#import "RootViewController.h"
#import "ReaderAppDelegate.h"
#import "DownloadController.h"

@class ReaderAppDelegate;
@class RootViewController;

@interface CustomCell : UITableViewCell <UIGestureRecognizerDelegate> {
    IBOutlet UIView *view;
	IBOutlet UILabel *titulo;
	IBOutlet UITextView *destaques;
	IBOutlet UIImageView *imagem;
    IBOutlet UIProgressView *porcentagemBarra;
    IBOutlet UILabel *porcentagemTexto;
	IBOutlet UIButton *accessoryViewImage;
	IBOutlet UIButton *iconViewImage;
    
	NSMutableDictionary *info;
	NSIndexPath *indexPath;
    NSInteger tipo;
    BOOL estadoSwipe;
    BOOL estadoDownload;
    
	RootViewController *delegate;
}

@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) UILabel *titulo;
@property (nonatomic, retain) UITextView *destaques;
@property (nonatomic, retain) UIImageView *imagem;
@property (nonatomic, retain) UIProgressView *porcentagemBarra;
@property (nonatomic, retain) UILabel *porcentagemTexto;

@property (nonatomic, retain) NSMutableDictionary *info;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (assign) NSInteger tipo;
@property (assign) BOOL estadoSwipe;
@property (assign) BOOL estadoDownload;

@property (assign) RootViewController *delegate;

- (void) swipeDireita;
- (void) swipeEsquerda;
- (IBAction) showAcessoryView;
- (IBAction) actionCell: (id)sender;

@end