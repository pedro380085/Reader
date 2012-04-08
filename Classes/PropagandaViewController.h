//
//  PropagandaViewController.h
//  Reader
//
//  Created by Pedro Góes on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constantes.h"
#import "Protocolos.h"
#import "SynthesizeSingleton.h"
#import "RootViewController.h"

@class RootViewController;

@interface PropagandaViewController : UIViewController {
    IBOutlet UIImageView *banner;
    NSArray *nomesBanners;
    NSTimer *__weak timer;
    id <PropagandaViewControllerDelegate> __weak delegate;
}

@property (nonatomic) NSArray *nomesBanners;
@property (nonatomic, weak) NSTimer *timer;
@property (weak) id <PropagandaViewControllerDelegate> delegate;

- (void)orientar;
- (void)atualizarBanner;
- (void)iniciarTimer;
- (void)invalidarTimer;

@end
