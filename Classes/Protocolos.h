//
//  Protocolos.h
//  Reader
//
//  Created by Pedro Góes on 29/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomCell;
@class PropagandaViewController;

@protocol DownloadViewControllerDataSource <NSObject>

- (void) novoCacheRecebido;

@end

@protocol RootViewControllerDelegate <NSObject>

- (void) removerArquivo: (NSString *) arquivo comCelula: (CustomCell *)celula;

@end

@protocol PropagandaViewControllerDelegate <NSObject>

- (void)propagandaApresentada:(PropagandaViewController *)pvc;
- (UIInterfaceOrientation)interfaceOrientation;


@end