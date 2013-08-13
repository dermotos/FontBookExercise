//
//  RDCAppState.m
//  CreateDigital
//
//  Created by Dermot on 14/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCAppState.h"

@implementation RDCAppState

+ (RDCAppState *)sharedInstance
{
    static RDCAppState *sharedInstance;
    
    @synchronized(self)
    {
        if (!sharedInstance)
        {
            sharedInstance = [[RDCAppState alloc] init];
            sharedInstance.fontNames = [[NSMutableArray alloc] init];
        }
        return sharedInstance;
    }
}

@end
