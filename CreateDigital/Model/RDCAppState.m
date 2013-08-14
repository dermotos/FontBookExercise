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

-(void)sortByAlpha{
    [self.fontNames sortUsingSelector:@selector(caseInsensitiveCompare:)];
    if(self.isSortReversed)
        [self reverseOrder];
}

-(void)sortByCharacterCount{
    [self.fontNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *string1 = (NSString*)obj1;
        NSString *string2 = (NSString*)obj2;
        if(string1.length == string2.length)
            return NSOrderedSame;
        else if(string1.length > string2.length)
            return self.isSortReversed ? NSOrderedAscending : NSOrderedDescending;
        else
            return self.isSortReversed ? NSOrderedDescending : NSOrderedAscending;
    }];
}

-(void)sortByDisplaySize{
    [self.fontNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        //As all fonts will scale equally in relation to each other at different font sizes, we
        //can just use an arbitrary font size for comparision/sorting reasons
        CGFloat fontSize = 10;
        
        NSString *string1 = (NSString*)obj1;
        NSString *string2 = (NSString*)obj2;
        CGSize string1Size = [string1 sizeWithFont:[UIFont fontWithName:string1 size:fontSize]];
        CGSize string2Size = [string2 sizeWithFont:[UIFont fontWithName:string2 size:fontSize]];
        
        if(string1Size.width == string2Size.width)
            return NSOrderedSame;
        else if(string1Size.width > string2Size.width)
            return self.isSortReversed ? NSOrderedAscending : NSOrderedDescending;
        else
            return self.isSortReversed ? NSOrderedDescending : NSOrderedAscending;
        
    }];
    
}

-(void)removeSort{
    self.sortingMode = RDCFontBookSortingUserDefined;
    [[NSNotificationCenter defaultCenter] postNotificationName:kRDCNotificationSortOrderRemoved object:nil];
}

-(void)sortByCurrentSortMethod{
    switch(self.sortingMode)
    {
        case RDCFontBookSortingAlpha:
            [self sortByAlpha];
            break;
            
        case RDCFontBookSortingCharCount:
            [self sortByCharacterCount];
            break;
            
        case RDCFontBookSortingDisplaySize:
            [self sortByDisplaySize];
            break;
    }
}

-(void)reverseOrder{
    self.fontNames = [[[self.fontNames reverseObjectEnumerator] allObjects] mutableCopy];
    
}


//Reverts all settings to default values
-(void)resetSort{
    self.isSortReversed = NO;
    self.sortingMode = RDCFontBookSortingAlpha;
    [self sortByAlpha];
}

-(void)resetLayout{
    self.textAlignment = NSTextAlignmentLeft;
    self.isTextBackwards = NO;
    
    
}

-(void)loadData{
    self.fontNames = [[UIFont familyNames] mutableCopy];
    [self sortByCurrentSortMethod];
    
}

//If there is a configuration file, move any fonts listed in it to the top of the list
-(void)prioritizeFavourites{
    
    NSString* configPath = [[NSBundle mainBundle] pathForResource:@"configuration" ofType:@"txt"];
    NSError *error;
    NSString* configuration = [NSString stringWithContentsOfFile:configPath encoding:NSUTF8StringEncoding error:&error];
    
    if(!error)
    {
        NSMutableArray *priorityFonts = [[configuration componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
        for(int x = priorityFonts.count-1; x >= 0;x--)
        {
            //If this exists in the font collection, remove it and re-insert it at the top of the list
            if([self.fontNames containsObject:[priorityFonts objectAtIndex:x]])
            {
                //The font exists and should be prioritized to the top
                [self.fontNames removeObject:[priorityFonts objectAtIndex:x]];
                [self.fontNames insertObject:[priorityFonts objectAtIndex:x] atIndex:0];
            }
        }
    }

}





@end
