//
//  RDCSettingsViewController.m
//  CreateDigital
//
//  Created by Dermot O Sullivan on 14/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCSettingsViewController.h"

@interface RDCSettingsViewController ()

@end 

@implementation RDCSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearSortControl) name:kRDCNotificationSortOrderRemoved object:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)clearSortControl{
    [self.sortOrderControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)alignmentDidChange:(id)sender {
    [RDCAppState sharedInstance].textAlignment = (self.alignmentControl.selectedSegmentIndex == 0) ? NSTextAlignmentLeft : NSTextAlignmentRight;
    [[NSNotificationCenter defaultCenter] postNotificationName:kRDCNotificationAlignmentChanged object:self];
}

- (IBAction)backwardsDidChange:(id)sender {
    [RDCAppState sharedInstance].isTextBackwards = self.backwardsSwitch.on;
    [[NSNotificationCenter defaultCenter] postNotificationName:kRDCNotificationBackwardsChanged object:self];
}

- (IBAction)sortOrderDidChange:(id)sender {
    if(self.sortOrderControl.selectedSegmentIndex == 0)
        [[RDCAppState sharedInstance] sortByAlpha];
    else if(self.sortOrderControl.selectedSegmentIndex == 1)
        [[RDCAppState sharedInstance] sortByCharacterCount];
    else
        [[RDCAppState sharedInstance] sortByDisplaySize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRDCNotificationSortOrderChanged object:self];
    
}

- (IBAction)reverseDidChange:(id)sender {
    [RDCAppState sharedInstance].isSortReversed = self.reverseOrderSwitch.on;
    [[RDCAppState sharedInstance] reverseOrder];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRDCNotificationSortReverseChanged object:self];
}

- (IBAction)resetTable:(id)sender {
    [[RDCAppState sharedInstance] resetSort];
    [[RDCAppState sharedInstance] resetLayout];
    [[RDCAppState sharedInstance] loadData];
    //Reset the physical buttons too
    [self.alignmentControl setSelectedSegmentIndex:0];
    [self.backwardsSwitch setOn:NO];
    [self.sortOrderControl setSelectedSegmentIndex:0];
    [self.reverseOrderSwitch setOn:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRDCNotificationContentReset object:self];
}
@end






