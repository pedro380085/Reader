//
//  RootViewController.m
//  Reader
//
//  Created by Pedro on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "ReaderAppDelegate.h"
#import "CustomCell.h"
#import "CacheDownloadController.h"
#import "PropagandaViewController.h"


@implementation RootViewController

@synthesize detailViewController, cache;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    self.navigationItem.title = NSLocalizedString(@"Edições", nil);
	
    // Definindo os delegates
	[CacheDownloadController sharedCacheDownloadController].delegate = self;
	[DownloadController sharedDownloadController].delegate = self;
    
    // Estado inicial da tabela
    tabelaModoEdicao = NO;
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    // Atualizando o cache
    [[CacheDownloadController sharedCacheDownloadController] atualizarCache];
}

#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            return NO;
        }
    }
    
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

- (void) novoCacheRecebido {
    [self carregarCache];
}

// Esse método lê o arquivo de cache e atribui 
- (void) carregarCache {
    
    // Cria string com caminho para o diretório dos pdfs
	NSString * docsDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"];
    
    NSMutableArray * a = [[NSMutableArray alloc] initWithContentsOfFile:[docsDir stringByAppendingPathComponent: CACHE_PADRAO_PLIST]];
    
    self.cache = [NSMutableArray arrayWithCapacity:2];
    [self.cache addObject:[NSMutableArray arrayWithCapacity:2]];
    [self.cache addObject:[NSMutableArray arrayWithCapacity:2]];
    
	// Cria um objeto para manipular os arquivos
	NSFileManager * localFileManager = [[NSFileManager alloc] init];  // mais seguro que defaultManager
    
    for (int i=0; i<[a count]; i++) {
        BOOL estado = [localFileManager fileExistsAtPath:[docsDir stringByAppendingPathComponent: [[a objectAtIndex:i] objectForKey:CACHE_ARQUIVO]]];
        NSMutableDictionary * d = [a objectAtIndex:i];
        
        if (estado == YES) {
            [[self.cache objectAtIndex:0] addObject:d];
        } else {
            [[self.cache objectAtIndex:1] addObject:d];
        }
    }
    
    
    // Força a tabela a ser atualizada com os novos dados
	[self.tableView reloadData];
}


- (void) removerArquivo: (NSString *) arquivo comCelula: (CustomCell *)celula {
    NSFileManager * localFileManager = [[NSFileManager alloc] init];  // mais seguro que defaultManager
    [localFileManager removeItemAtPath:[[NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"] stringByAppendingPathComponent:arquivo] error:nil];
    
    [[self.cache objectAtIndex:celula.indexPath.section] removeObjectAtIndex:celula.indexPath.row];
    
    // O método deleteRowsAtIndexPaths exige que seu argumento seja um array, por isso criamos o array paths
	NSArray * paths = [NSArray arrayWithObject: celula.indexPath];
	[self.tableView deleteRowsAtIndexPaths:paths withRowAnimation: UITableViewRowAnimationRight];
    
    [self performSelector:@selector(carregarCache) withObject:nil afterDelay:ANIMACAO_PADRAO];
    
}

- (IBAction)botaoEditarPressionado {
    // Altera o estado do modo de edição
    self.tableView.allowsSelection = tabelaModoEdicao;
    tabelaModoEdicao = !tabelaModoEdicao;
    
    // Cria um dicionário para poder enviar para as células o estado de edição da tabela
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:tabelaModoEdicao] forKey:EditButtonPushedNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:EditButtonPushed object:nil userInfo:userInfo];
}

- (IBAction) sobre {
	// Informa usuário sobre como modificar as células da tabela
    UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:NSLocalizedString(@"Sobre", nil) 
						  message: NSLocalizedString(@"Sobre Mensagem", @"Aplicativo para leitura das revistas dos Arquivos Brasileiros de Oftamologia (ABO).\n\nDesenvolvedor: Pedro P. M. Góes\n\nVersão atual: 1.2\nRelease: Novembro/2011\n")
						  delegate:self 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
}

- (double)calcularAlturaParaIndex:(NSIndexPath *)indexPath {
    // Dicionário com todas as informações para a célula
    NSMutableDictionary * d = [[cache objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    UITextView *v = [[UITextView alloc] init];
    [v setText:[d objectForKey:CACHE_DESTAQUES]];
    [self.view addSubview:v];
    double altura = v.contentSize.height;
    [v removeFromSuperview];
    
    return altura;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {    
    return 2;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ([[cache objectAtIndex:section] count]);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Dicionário com todas as informações para a célula
    NSMutableDictionary * d = [[cache objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
	
	static NSString * CustomCellIdentifier = @"CustomCellIdentifier";
    CustomCell * celula = (CustomCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    
	if (celula == nil) {
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[CustomCell class]]) {
				celula = [(CustomCell *)oneObject init];
			}
		}
	}
	
	// Construindo a célula
    celula.titulo.text = [d objectForKey:CACHE_TITULO]; 
	celula.imagem.image = [UIImage imageWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:[d objectForKey:CACHE_IMAGEM]]];
	celula.destaques.text = [d objectForKey:CACHE_DESTAQUES]; 
	celula.tipo = ([indexPath section] == 0 ? kTipoVermelho : kTipoAzul);
	celula.indexPath = indexPath;
    celula.delegate = self;
    celula.info = d;
    
    // Restaurando a interface
    celula.titulo.hidden = NO;
    celula.imagem.hidden = NO;
    celula.destaques.hidden = NO;
    celula.porcentagemBarra.hidden = YES;
    celula.porcentagemTexto.hidden = YES;
    celula.estadoDownload = NO;
    //celula.contentMode = UIViewContentModeRedraw;
    
    [[DownloadController sharedDownloadController] atualizarInterfaceParaTabelaComCelula:celula paraPath:indexPath];
    
    // Configurando os frames
    //cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height*2);
    //cell.view.frame = CGRectMake(cell.view.frame.origin.x, cell.view.frame.origin.y, cell.view.frame.size.width, cell.view.frame.size.height*2);
    //cell.destaques.frame = CGRectMake(cell.destaques.frame.origin.x, cell.destaques.frame.origin.y, cell.destaques.frame.size.width, cell.destaques.frame.size.height*2);
	
	return celula;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSArray * v = [[NSArray alloc] initWithObjects:
                   NSLocalizedString(@"Arquivos no iPad", nil),
                   NSLocalizedString(@"Arquivos no servidor", nil),
                   nil];
	NSString * key = [v objectAtIndex:section];
	return key;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%f", [self calcularAlturaParaIndex:indexPath]);
    //return 400;
	//return [self calcularAlturaParaIndex:indexPath];
    return kTableViewRowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Somente apresenta o pdf se o arquivo já estiver sido baixado
    if (indexPath.section == 0) {
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            if (!self.detailViewController) {
                self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
            }
            [detailViewController apresentarPdf:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent: [[[self.cache objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:CACHE_ARQUIVO]]];
            
            [self.navigationController pushViewController:self.detailViewController animated:YES];
        } else {
            if (!self.detailViewController) {
                // Receives the detailViewController -- Shouldn't be doing that / dangerous
                self.detailViewController = (DetailViewController *)self.splitViewController.delegate;
            }
            [detailViewController apresentarPdf:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent: [[[self.cache objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:CACHE_ARQUIVO]]];
        }

    } else {

        
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Download" 
                              message: NSLocalizedString(@"Download Mensagem", @"Para ler a revista, deslize o dedo sobre a célula e confirme o download.")
                              delegate:self 
                              cancelButtonTitle:@"Ok" 
                              otherButtonTitles:nil];
        [alert show];
         
    }/*else {
      // Opção para fazer download da revista
        DownloadController * downloadController = [DownloadController sharedDownloadController];
        NSMutableDictionary *info = [[cache objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [downloadController adicionarURL:[URL_ARQUIVO stringByAppendingFormat: [info objectForKey:CACHE_ARQUIVO], nil] salvandoComo:[info objectForKey:CACHE_ARQUIVO] comCelula:(CustomCell *)[tableView cellForRowAtIndexPath:indexPath] comTamanho:[[info objectForKey:CACHE_TAMANHO] intValue] comCache:NO];
    }*/
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

