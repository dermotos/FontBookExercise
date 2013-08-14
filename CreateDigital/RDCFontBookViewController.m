//
//  RDCFontBookViewController.m
//  CreateDigital
//
//  Created by Dermot on 14/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCFontBookViewController.h"
#import "IIViewDeckController.h"

#define MAX_FONT_SIZE 30

@interface RDCFontBookViewController ()

@end

@implementation RDCFontBookViewController
{
    NSString *kCellIdentifier;
    CGFloat fontSize;
    NSMutableArray *filteredSearch;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    [[RDCAppState sharedInstance] loadData];
    
    kCellIdentifier = @"fontCell";
    self.title = @"Font Book";
    int maxWidth = self.tableView.frame.size.width - 50;
    /*
     Note: reasoning for using 50 padding above.
     The UITableViewCell displays its content in its ContentView. The width of this changes based on many factors, including if
     an image is displayed (and its width), the tableviews margins (changing in iOS7), device orientation, device type if in landscape (iPhone 4S vs 5 screens)
     text margins within the UITextLabel itself, and if a detail disclosure is visible. A UITableViewCell could be checked to see exactly what size the UITextField would
     be, but it would involve considerable effort. Estimating 50 is sufficient here. If the app became more complex, with landscape support, images etc, then this should
     be revisited and calculated dynamically.
     */
    
    //Calculate the correct font size for all fonts. This is the smallest font size that will fit all fonts should be used
    fontSize = CGFLOAT_MAX;
    for (NSString *fontName in [RDCAppState sharedInstance].fontNames) {
        //NSLog(@"%@",fontName);
        CGFloat thisFontSize;
        [fontName sizeWithFont:[UIFont fontWithName:fontName size:60]
                   minFontSize:0 actualFontSize:&thisFontSize
                      forWidth:maxWidth
                 lineBreakMode: NSLineBreakByClipping];
        //NSLog(@"%f",thisFontSize);
        if(thisFontSize < fontSize)
            fontSize = thisFontSize;
    }
    
    if(fontSize > MAX_FONT_SIZE)
        fontSize = MAX_FONT_SIZE;
    
    filteredSearch = [[NSMutableArray alloc] initWithCapacity:[RDCAppState sharedInstance].fontNames.count];
    
    [[RDCAppState sharedInstance] sortByAlpha];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
    [leftButton setTintColor:[UIColor orangeColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    [self.editButtonItem setTintColor:[UIColor orangeColor]];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)showSettings:(id) sender{
    //Hierarchy: self (this controller) >> Navigation Controller (the centre controller) >> Deck Controller
    IIViewDeckController *deckController = ((IIViewDeckController*)self.parentViewController.parentViewController);
    [deckController toggleTopView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:kRDCNotificationAlignmentChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:kRDCNotificationBackwardsChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:kRDCNotificationSortOrderChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:kRDCNotificationSortReverseChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kRDCNotificationContentReset object:nil];
}

-(void)refreshTableView{
    [self.tableView beginUpdates];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:[RDCAppState sharedInstance].fontNames.count];
    for (int x = 0; x< [RDCAppState sharedInstance].fontNames.count; x++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:x inSection:0]];
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

-(void)reloadTableView{
    [self.tableView reloadData];
}



-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return filteredSearch.count;
    }
    else
    {
       return [RDCAppState sharedInstance].fontNames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(!cell)
    {
        //No cell dequeued, initialize a new one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        
    }
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.font = [UIFont fontWithName:[filteredSearch objectAtIndex:indexPath.row]   size:fontSize];
        cell.textLabel.text = [[RDCAppState sharedInstance] isTextBackwards] ? [self reverseString:[filteredSearch objectAtIndex:indexPath.row]] : [filteredSearch objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = [RDCAppState sharedInstance].textAlignment;
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:[[[RDCAppState sharedInstance] fontNames] objectAtIndex:indexPath.row]   size:fontSize];
        cell.textLabel.text = [[RDCAppState sharedInstance] isTextBackwards] ? [self reverseString:[[[RDCAppState sharedInstance] fontNames] objectAtIndex:indexPath.row]] : [[[RDCAppState sharedInstance] fontNames] objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = [RDCAppState sharedInstance].textAlignment;
    }
    return cell;

}

-(NSString*) reverseString:(NSString*) originalString{
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[originalString length]];
    
    [originalString enumerateSubstringsInRange:NSMakeRange(0,[originalString length])
                                       options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                                    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                        [reversedString appendString:substring];
                                    }];
    
    return [NSString stringWithString:reversedString];
    
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString *movingItem = [[RDCAppState sharedInstance].fontNames objectAtIndex:sourceIndexPath.row];
    [[RDCAppState sharedInstance].fontNames removeObjectAtIndex:sourceIndexPath.row];
    [[RDCAppState sharedInstance].fontNames insertObject:movingItem atIndex:destinationIndexPath.row];
    [[RDCAppState sharedInstance] removeSort];
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[RDCAppState sharedInstance].fontNames removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    IIViewDeckController *deckController = ((IIViewDeckController*)self.parentViewController.parentViewController);
    if(editing)
    {
        [deckController setPanningMode:IIViewDeckNoPanning];
    }
    else
    {
        [deckController setPanningMode:IIViewDeckNavigationBarPanning];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    RDCFontPreviewViewController *fontPreviewController;
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        fontPreviewController= [[RDCFontPreviewViewController alloc]
                                initWithFont:[UIFont fontWithName:[filteredSearch objectAtIndex:indexPath.row ] size:12]];
    }
    else
    {
        fontPreviewController= [[RDCFontPreviewViewController alloc]
                                initWithFont:[UIFont fontWithName:[[RDCAppState sharedInstance].fontNames objectAtIndex:indexPath.row ] size:12]];
    }
    
   

    [self.navigationController pushViewController:fontPreviewController animated:YES];
}





-(void)filterFontNames:(NSString*)searchText scope:(NSString*)scope {
    [filteredSearch removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    filteredSearch = [NSMutableArray arrayWithArray:[[RDCAppState sharedInstance].fontNames filteredArrayUsingPredicate:predicate]];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterFontNames:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {

    [self filterFontNames:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

    return YES;
}


















 


@end
