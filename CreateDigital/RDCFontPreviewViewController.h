//
//  RDCFontPreviewViewController.h
//  CreateDigital
//
//  Created by Dermot on 14/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDCFontPreviewViewController : UIViewController

@property (strong,nonatomic) UIFont * displayFont;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;

- (id)initWithFont:(UIFont *)font;

- (IBAction)sliderDidChange:(id)sender;


@end
