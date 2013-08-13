//
//  RDCAppState.h
//  CreateDigital
//
//  Created by Dermot on 14/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDCAppState : NSObject

+ (RDCAppState *)sharedInstance;

@property NSMutableArray * fontNames;

@end
