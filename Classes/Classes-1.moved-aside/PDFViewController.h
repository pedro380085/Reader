//
//  PDFViewController.h
//  Reader
//
//  Created by Pedro on 08/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PDFViewController : UIViewController  {
	UIWebView	*webView;
	NSURL	*pdfUrl;
}

@property (nonatomic, retain) IBOutlet UIWebView	*webView;
@property (nonatomic, retain) NSURL			*pdfUrl;

@end
