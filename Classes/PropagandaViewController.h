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
#import "DetailViewController.h"

@interface PropagandaViewController : UIViewController {
    IBOutlet UIImageView *banner;
    NSArray *nomesBanners;
    NSTimer *timer;
    DetailViewController *delegate;
}

@property (nonatomic, retain) NSArray *nomesBanners;
@property (nonatomic, assign) NSTimer *timer;
@property (assign) DetailViewController *delegate;

- (void)atualizarBanner;
- (void)iniciarTimer;
- (void)invalidarTimer;

@end
