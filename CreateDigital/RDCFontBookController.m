//
//  RDCFontBookController.m
//  CreateDigital
//
//  Created by Dermot on 14/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCFontBookController.h"

#define MAX_FONT_SIZE 30

@interface RDCFontBookController ()

@end

@implementation RDCFontBookController{
    NSString *kCellIdentifier;
    CGFloat fontSize;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Font Book";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    kCellIdentifier = @"fontCell";
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
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:kRDCNotificationAlignmentChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:kRDCNotificationBackwardsChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:kRDCNotificationSortOrderChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:kRDCNotificationSortReverseChanged object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Called when the layout configuration changes and the table requires a refresh
-(void)refreshTableView{
    [self.tableView beginUpdates];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:[RDCAppState sharedInstance].fontNames.count];
    for (int x = 0; x< [RDCAppState sharedInstance].fontNames.count; x++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:x inSection:0]];
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [RDCAppState sharedInstance].fontNames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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








@end
