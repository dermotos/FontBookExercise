//
//  RDCFontPreviewViewController.m
//  CreateDigital
//
//  Created by Dermot on 14/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCFontPreviewViewController.h"

@interface RDCFontPreviewViewController ()

@end

@implementation RDCFontPreviewViewController
{
    NSString *originalFontFamilyName;
}

- (id)initWithFont:(UIFont *)font
{
    self = [super initWithNibName:@"RDCFontPreviewViewController" bundle:nil];
    if (self) {
        self.displayFont = font;
    }
    return self;
}

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
    self.contentLabel.text = @"Aa   Bb  Cc   Dd   Ee   Ff   Gg   Hh   Ii   Jj   Kk   Ll   Mm   Nn    Oo   Pp    Qq   Rr   Ss   Tt   Uu   Vv   Ww   Xx   Yy    Zz\n1 2 3 4 5 6 7 8 9 0";
    self.contentLabel.font = [self.displayFont fontWithSize:self.sizeSlider.value];
    originalFontFamilyName = self.displayFont.familyName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderDidChange:(id)sender {
    self.contentLabel.font = [self.displayFont fontWithSize:self.sizeSlider.value];
}

@end
