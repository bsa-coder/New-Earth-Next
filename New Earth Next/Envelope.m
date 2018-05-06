//
//  Envelope.m
//  New Earth
//
//  Created by Scott Alexander on 12/24/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "Envelope.h"

@implementation Envelope

@synthesize myEnvDelegate;
//@synthesize aUnit, theUnits, theViewScale, theUnitLocation, theTiles;
@synthesize aUnit, theViewScale, theUnitLocation, theTiles;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.contentMode = UIViewContentModeRedraw;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    // Drawing code
    [self setDefaults];
    
    theViewScale = [self.myEnvDelegate scaleForDrawingEnv:self];
    CGContextRef thisContext = UIGraphicsGetCurrentContext();
    
    thisContext = UIGraphicsGetCurrentContext();
    
    // Drawing code
//    [aUnit showMyEnvelope:aUnit
//           atPoint:theUnitLocation
//           atScale:theViewScale
//         inContext:thisContext];
    
    
    if(!aUnit)
    {
        aUnit = [[NewTech alloc] init];
    }
    /*
    theUnits = [myEnvDelegate unitsToDrawEnv:self];
    
    if ([theUnits count] > 0) {
        for (NSInteger i = 0; i < [theUnits count]; i++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            aUnit = [theUnits unitAtIndexPath:indexPath];
            theUnitLocation = aUnit.myLoc;
            [aUnit showMyEnvelope:aUnit atPoint:theUnitLocation atScale:theViewScale inContext:thisContext];

        }
    }
    */
    theTiles = [myEnvDelegate tilesToDrawEnv:self];
    if(theTiles)
    {
        CGContextSaveGState(thisContext);
        CGContextBeginPath(thisContext);

        for ( NSString *key in [theTiles allKeys]) {
            GeoTile* thisTile = (GeoTile*) [theTiles objectForKey:key];
            //do what you want to do with items
            if ([thisTile valueOfResourcesAndToxins] == 0) {
                CGPoint tileVertex = CGPointFromString([thisTile tileLocation]);
                CGRect tile01 = CGRectMake(tileVertex.x, tileVertex.y, [myEnvDelegate gridSpacingEnv:self] / 8.0, [myEnvDelegate gridSpacingEnv:self] / 8.0);
                CGContextAddRect(thisContext, tile01);

            }
            else {
                [thisTile drawResourceViewInContext:thisContext forView:self];
                [thisTile drawTerrainViewInContext:thisContext forView:self];

            }
//            NSLog(@"%@", [dictionary objectForKey:key]);
        }
        
        [[UIColor colorWithRed:0.2 green:0.2 blue:0.0 alpha:0.75] setFill];
//        [[UIColor orangeColor] setFill];
//        [[self showMyColor] setFill];
        [[UIColor orangeColor] setStroke];
//        [[self showMyColor] setStroke];
        
        CGContextDrawPath(thisContext, kCGPathFillStroke);
        CGContextRestoreGState(thisContext);

        
    }
}


- (void) setDefaults
{
//    NSLog(@"implement setDefaults for UnitView");
}

@end
