//
//  RDCAppDelegate.h
//  CreateDigital
//
//  Created by Dermot on 13/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "IIViewDeckController.h"
#import <UIKit/UIKit.h>

@interface RDCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) IIViewDeckController *deckController;

@end
