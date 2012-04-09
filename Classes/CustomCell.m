//
//  CustomCell.m
//  Reader
//
//  Created by Pedro on 22/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize view, titulo, destaques, imagem, porcentagemBarra, porcentagemTexto;
@synthesize info, indexPath, tipo, estadoSwipe, estadoDownload;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self = [self init];
    }
    return self;
}

- (id)init {
	// Criando e configura um objeto para detectar swipes na célula
	UISwipeGestureRecognizer *__strong recognizerDireita, *__strong recognizerEsquerda;
	
    recognizerDireita = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDireita)];
    recognizerDireita.delegate = self;
    recognizerDireita.direction = UISwipeGestureRecognizerDirectionRight;
	[self addGestureRecognizer:recognizerDireita];
	
	recognizerEsquerda = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeEsquerda)];
    recognizerEsquerda.delegate = self;
	recognizerEsquerda.direction = UISwipeGestureRecognizerDirectionLeft;
	[self addGestureRecognizer:recognizerEsquerda];
	
	// Variável interna
	self.estadoSwipe = NO;
    self.estadoDownload = NO;
    
    // Registra a célula para receber notificações relativas ao modo de edição
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleSwipes:) name:EditButtonPushed object:nil];

	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


#pragma mark -
#pragma mark Setter / Getter tipo

- (void)setTipo: (int) t {
    
    tipo = t;
	
	/* 
		Documentação para tipo da view
		(1) - Excluir (Fornece um botão acessório vermelho escrito Excluir e um ícone vermelho negativo)
		(2) - Baixar (Fornece um botão acessório azul escrito Baixar e um ícone azul positivo)
	 */
	

	if (tipo == kTipoAzul) {
		[accessoryViewImage setImage: [[UIImage alloc] initWithContentsOfFile: 
											 [[NSBundle mainBundle] pathForResource:@"button blue" ofType:@"png"]] 
												forState:UIControlStateNormal];
		[iconViewImage setImage: [[UIImage alloc] initWithContentsOfFile:
										[[NSBundle mainBundle] pathForResource:@"icon blue add" ofType:@"png"]]
											forState:UIControlStateNormal];
	} else if (tipo == kTipoVermelho) {
		[accessoryViewImage setImage: [[UIImage alloc] initWithContentsOfFile: 
											[[NSBundle mainBundle] pathForResource:@"button red" ofType:@"png"]]
												forState:UIControlStateNormal];
		[iconViewImage setImage: [[UIImage alloc] initWithContentsOfFile: 
									   [[NSBundle mainBundle] pathForResource:@"icon red remove" ofType:@"png"]] 
											forState:UIControlStateNormal];
	}
}

- (int)tipo {
    return tipo;
}

#pragma mark -
#pragma mark Notification Methods

- (void)toggleSwipes:(NSNotification *)n {
    if ([[[n userInfo] objectForKey:EditButtonPushedNotification] boolValue] == YES) {
        [self swipeDireita];
    } else {
        [self swipeEsquerda];
    }
    
}

#pragma mark -
#pragma mark User Methods

// Mostra o ícone (+ ou -)
- (void) swipeDireita {
    if (estadoDownload == NO) {
        [UIView animateWithDuration:ANIMACAO_PADRAO animations:^{view.frame = CGRectMake(5.0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);}];
    }
}

// Esconde o ícone (+ ou -)
- (void) swipeEsquerda {
	if (estadoSwipe == YES) {
		[self showAcessoryView];
	}
    [UIView animateWithDuration:ANIMACAO_PADRAO animations:^{view.frame = CGRectMake(-30.0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);}];
}

- (IBAction) showAcessoryView {
	CGFloat x;
	
	/* 
		Documentação para váriavel state
		(YES) -  AcessoryView habilitada
		(NO) -  AcessoryView desabilitada
	 */

	
	if (estadoSwipe == YES) {
		estadoSwipe = NO;
		[UIView animateWithDuration:ANIMACAO_PADRAO animations:^{iconViewImage.transform = CGAffineTransformMakeRotation(0.0f);}];
		x = 366.0f;
	} else {
		estadoSwipe = YES;
        [UIView animateWithDuration:ANIMACAO_PADRAO animations:^{iconViewImage.transform = CGAffineTransformMakeRotation(M_PI / 2.0f);}];
		x = 236.0f;
	}
    
    [UIView animateWithDuration:ANIMACAO_PADRAO animations:^{accessoryViewImage.frame = CGRectMake(x, accessoryViewImage.frame.origin.y, accessoryViewImage.frame.size.width, accessoryViewImage.frame.size.height);}];
}

- (IBAction) actionCell: (id) sender {
    // Iremos analisar o tipo da view e encaminhar as ações para o local adequado
    
    if (tipo == kTipoAzul) {
        DownloadController * downloadController = [DownloadController sharedDownloadController];
        [downloadController adicionarURL:[URL_ARQUIVO stringByAppendingFormat: [info objectForKey:CACHE_ARQUIVO], nil] salvandoComo:[info objectForKey:CACHE_ARQUIVO] comPath:indexPath comTamanho:[[info objectForKey:CACHE_TAMANHO] intValue] comCache:NO];
        estadoDownload = YES;
    } else if (tipo == kTipoVermelho) {
        // Removendo o objeto do array antes de removê-lo graficamente
        [delegate removerArquivo:[info objectForKey:CACHE_ARQUIVO] comCelula:self];
    }
	
	// Redefine para o modelo padrão
	NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:EditButtonPushedNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:EditButtonPushed object:nil userInfo:userInfo];
}

#pragma mark -
#pragma mark Gesture Recognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}



@end
