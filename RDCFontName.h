//
//  RDCFontName.h
//  CreateDigital
//
//  Created by Dermot on 14/08/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//  Stores all the details necessary to display a font onscreen.

#import <Foundation/Foundation.h>

@interface RDCFontName : NSObject
@property NSString *fontName;
@property NSString *displayText;
@property int renderedWidth;

@end
