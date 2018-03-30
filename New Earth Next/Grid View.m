//
//  Grid View.m
//  New Earth
//
//  Created by Scott Alexander on 11/21/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "Grid View.h"

@implementation Grid_View

@synthesize gridLineColor;
@synthesize gridSpacing;
@synthesize gridYOffset, gridXOffset;
@synthesize gridLineWidth;
@synthesize gridXOrigin, gridYOrigin;
@synthesize theGlobals;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.contentMode = UIViewContentModeRedraw;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
//    int numCols = 0;
//    int numRows = 0;
    theGlobals = [NewEarthGlobals sharedSelf]; // [[NewEarthGlobals alloc] init];
    
// Drawing code
    [self setDefaults];
    [self drawGridMethodTwoInContext];
    
}

-(void) drawGridMethodTwoInContext//:(CGContextRef)thisContext
{
    NSMutableDictionary* theTiles = theGlobals.geoTileList;
    if(theTiles)
    {
        CGContextRef thisContext = UIGraphicsGetCurrentContext();
        CGContextSaveGState(thisContext);

        for ( NSString *key in [theTiles allKeys]) {
            //do what you want to do with items
            if ((GeoTile*)[theTiles objectForKey:key]) {
                GeoTile* newTile = [theTiles objectForKey:key];
                CGPoint tileVertex = CGPointFromString([newTile tileLocation]);
                CGRect tileRect = CGRectMake(tileVertex.x, tileVertex.y, theGlobals.gridSpacing, theGlobals.gridSpacing);
                if ([newTile valueOfResourcesAndToxins] > 0) {
                    [[UIColor clearColor] setFill];
                }
                else
                {
                    [[UIColor colorWithRed:0.2 green:0.2 blue:0.0 alpha:0.75] setFill];
                }
                [[UIColor orangeColor] setStroke];
                CGContextAddRect(thisContext, tileRect);
                CGContextDrawPath(thisContext, kCGPathFillStroke);
            }
        }

        CGContextRestoreGState(thisContext);
    }
}

-(void) setDefaults
{
//    self.backgroundColor = [UIColor whiteColor];
//    self.opaque = YES;
    self.contentMode = UIViewContentModeRedraw;
    
//    self.gridSpacing = theGlobals.gridSpacing;
//    self.gridYOffset = theGlobals.gridYOrigin;
//    self.gridXOrigin = theGlobals.gridXOrigin;
    
    self.gridSpacing = [_myGridDelegate gridSpacingGlobal:self];
    self.gridYOrigin = [_myGridDelegate gridYOriginGlobal:self];
    self.gridXOrigin = [_myGridDelegate gridXOriginGlobal:self];
//    self.gridSpacing = 100.0;
//    self.gridYOrigin = 182.0;
//    self.gridXOrigin = 171.0;
    
    if(self.contentScaleFactor == 2.0)
    {
        self.gridLineWidth = 0.5;
        self.gridXOffset = 0.25;
        self.gridYOffset = 0.25;
    }
    else
    {
        self.gridLineWidth = 1.0;
        self.gridXOffset = 0.5;
        self.gridYOffset = 0.5;
    }
    
    self.gridLineColor = [UIColor redColor];
}

@end
