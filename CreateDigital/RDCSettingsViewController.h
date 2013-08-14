//
//  RDCSettingsViewController.h
//  CreateDigital
//
//  Created by Dermot O Sullivan on 14/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDCSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *alignmentControl;
@property (weak, nonatomic) IBOutlet UISwitch *backwardsSwitch;
- (IBAction)alignmentDidChange:(id)sender;
- (IBAction)backwardsDidChange:(id)sender;


@end
