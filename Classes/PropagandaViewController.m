//
//  PropagandaViewController.m
//  Reader
//
//  Created by Pedro Góes on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PropagandaViewController.h"

@implementation PropagandaViewController

@synthesize nomesBanners;
@synthesize timer;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        nomesBanners = [NSArray arrayWithObjects:@"Allergan.jpg", @"Sistayne.jpg", @"Xperio.jpg", nil];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    int aleatorio = arc4random() % [nomesBanners count];
    [banner setImage:[UIImage imageNamed:[nomesBanners objectAtIndex:aleatorio]]];
    
    [self.view setNeedsDisplay];
}


- (void)orientar {
    //UIInterfaceOrientation u = self.interfaceOrientation;
    if (!UIInterfaceOrientationIsLandscape([delegate interfaceOrientation])) {
        self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
    } else {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    [self.view setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
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

- (void)atualizarBanner {
    [[NSNotificationCenter defaultCenter] postNotificationName:PropagandaApresentadaNotification object:nil];
    [delegate propagandaApresentada:self];
}

- (void)iniciarTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:BANNER_TEMPO target:self selector:@selector(atualizarBanner) userInfo:nil repeats:NO];
}

- (void)invalidarTimer {
    [timer invalidate];
}

@end
