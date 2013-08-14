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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    for (NSString *fontName in [UIFont familyNames]) {
        //NSLog(@"%@",fontName);
        CGFloat thisFontSize;
        [fontName sizeWithFont:[UIFont fontWithName:fontName size:60]
                   minFontSize:0 actualFontSize:&thisFontSize
                      forWidth:maxWidth
                 lineBreakMode: NSLineBreakByClipping];
        //NSLog(@"%f",thisFontSize);
        if(thisFontSize < fontSize)
            fontSize = thisFontSize;
        
        [[[RDCAppState sharedInstance] fontNames] addObject:fontName];
    }
    
    if(fontSize > MAX_FONT_SIZE)
        fontSize = MAX_FONT_SIZE;
    
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
    [deckController openTopViewAnimated:YES];
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
    return [RDCAppState sharedInstance].fontNames.count;
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
    
    cell.textLabel.font = [UIFont fontWithName:[[[RDCAppState sharedInstance] fontNames] objectAtIndex:indexPath.row]   size:fontSize];
    cell.textLabel.text = [[RDCAppState sharedInstance] isTextBackwards] ? [self reverseString:[[[RDCAppState sharedInstance] fontNames] objectAtIndex:indexPath.row]] : [[[RDCAppState sharedInstance] fontNames] objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = [RDCAppState sharedInstance].textAlignment;
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


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
