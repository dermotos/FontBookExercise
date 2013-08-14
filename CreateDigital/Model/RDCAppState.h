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

typedef enum {
    RDCFontBookSortingAlpha,
    RDCFontBookSortingCharCount,
    RDCFontBookSortingDisplaySize,
    RDCFontBookSortingUserDefined
} RDCFontBookSorting;



@property NSMutableArray * fontNames;

@property NSTextAlignment textAlignment;
@property bool isTextBackwards;

@property RDCFontBookSorting sortingMode;
@property bool isSortReversed;

-(void)resetSort;
-(void)resetLayout;
-(void)reloadData;
-(void)sortByAlpha;
-(void)sortByCharacterCount;
-(void)sortByDisplaySize;
-(void)reverseOrder;
-(void)removeSort;


@end
