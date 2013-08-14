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
    [RDCAppState sharedInstance].isBackwards = self.backwardsSwitch.on;
    [[NSNotificationCenter defaultCenter] postNotificationName:kRDCNotificationBackwardsChanged object:self];
}
@end
