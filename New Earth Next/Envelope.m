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
    
    NSMutableArray* gridPaths = [[NSMutableArray alloc] init];
    _theUnits = [myEnvDelegate unitsToDrawEnv:self];
    
    if ([_theUnits count] > 0) {
        for (NSInteger i = 0; i < [_theUnits count]; i++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            aUnit = [_theUnits unitAtIndexPath:indexPath];
            theUnitLocation = aUnit.myLoc;
            [aUnit showMyEnvelope:aUnit atPoint:theUnitLocation atScale:theViewScale inContext:thisContext];
            NSMutableArray* gridPaths2 = [[NSMutableArray alloc] init];

            for (int j = 0; j < [aUnit.pathsToSources count] ; j++) {
                for (int k = 0; k < [aUnit.pathsToSources[j] count]; k++) {
                    [gridPaths addObject:aUnit.pathsToSources[j][k]];
                }
            }
        }
    }
    
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
                [thisTile drawBackgroundInContext:thisContext forView:self];
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
    
    // step through the segments
    if(gridPaths)
    {
        while ([gridPaths count] > 0) {
            segment* aSeg = gridPaths[0];
            if (gridPaths[0] != nil) { [gridPaths removeObjectAtIndex: 0]; }
        
            switch (aSeg.myStatus) {
                case 0:
                    break;
                case 1:
                    [self drawItemPlanning:aSeg];
                    break;
                case 2:
                    [self drawItemBuild:aSeg];
                    break;
                case 3:
                    [self drawItemOff:aSeg];
                    break;
                case 4:
                    [self drawItemOn:aSeg];
                    break;

                default:
                    break;
            }
        }
    }
}

-(void) drawItemPlanning: (segment*) aSeg {
    
    UIBezierPath* pathToSee = [[UIBezierPath alloc] init];
    
    CGPoint startPt;
    if (aSeg.srcID == 0) {
        startPt = aSeg.myLoc;
    } else {
        startPt = [aSeg.srcID myLoc];
    }
    
    [pathToSee moveToPoint:startPt];
    [pathToSee addLineToPoint:aSeg.myLoc];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    CGContextSaveGState(currentContext);
    CGContextBeginPath(currentContext);

    
    
    
    //    CGContextSetLineCap(currentContext, kCGLineCapRound);
//    CGContextSetLineJoin(currentContext, kCGLineJoinRound);
//    CGContextSetLineWidth(currentContext, 4);
    CGContextSetLineWidth(currentContext, 1);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blackColor].CGColor);
//    const double hmmm[2] = {2,8};
//    CGContextSetLineDash(currentContext, 2, hmmm, 2);
    const double hmmm[2] = {1,4};
    CGContextSetLineDash(currentContext, 1, hmmm, 1);

    CGContextBeginPath(currentContext);
    CGContextAddPath(currentContext, pathToSee.CGPath);
    CGContextDrawPath(currentContext, kCGPathStroke);



    CGContextRestoreGState(currentContext);
    
    currentContext = nil;
}
-(void) drawItemBuild: (segment*) aSeg {
    UIBezierPath* pathToSee = [[UIBezierPath alloc] init];
    
    CGPoint startPt;
    if (aSeg.srcID == 0) {
        startPt = aSeg.myLoc;
    } else {
        startPt = [aSeg.srcID myLoc];
    }
    
    [pathToSee moveToPoint:startPt];
    [pathToSee addLineToPoint:aSeg.myLoc];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(currentContext);
    CGContextBeginPath(currentContext);

    
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineJoin(currentContext, kCGLineJoinRound);
    CGContextSetLineWidth(currentContext, 2);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor grayColor].CGColor);

    CGContextBeginPath(currentContext);
    CGContextAddPath(currentContext, pathToSee.CGPath);
    CGContextDrawPath(currentContext, kCGPathStroke);

    

    CGContextRestoreGState(currentContext);

    currentContext = nil;
}
-(void) drawItemOff: (segment*) aSeg {
    UIBezierPath* pathToSee = [[UIBezierPath alloc] init];
    
    CGPoint startPt;
    if (aSeg.srcID == 0) {
        startPt = aSeg.myLoc;
    } else {
        startPt = [aSeg.srcID myLoc];
    }
    
    [pathToSee moveToPoint:startPt];
    [pathToSee addLineToPoint:aSeg.myLoc];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextBeginPath(currentContext);

    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineJoin(currentContext, kCGLineJoinRound);
    CGContextSetLineWidth(currentContext, 4);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor grayColor].CGColor);
    CGContextBeginPath(currentContext);
    CGContextAddPath(currentContext, pathToSee.CGPath);
    CGContextDrawPath(currentContext, kCGPathStroke);

    

    CGContextRestoreGState(currentContext);

    currentContext = nil;
}
-(void) drawItemOn: (segment*) aSeg {
    UIBezierPath* pathToSee = [[UIBezierPath alloc] init];
    
    CGPoint startPt;
    if (aSeg.srcID == 0) {
        startPt = aSeg.myLoc;
    } else {
        startPt = [aSeg.srcID myLoc];
    }
    
    [pathToSee moveToPoint:startPt];
    [pathToSee addLineToPoint:aSeg.myLoc];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextBeginPath(currentContext);

    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineJoin(currentContext, kCGLineJoinRound);
    CGContextSetLineWidth(currentContext, 4);
    switch (aSeg.myType) {
        case 5:
            CGContextSetStrokeColorWithColor(currentContext, [UIColor yellowColor].CGColor);
            break;
            
        case 1:
            CGContextSetStrokeColorWithColor(currentContext, [UIColor blueColor].CGColor);
            break;
            
        default:
            CGContextSetStrokeColorWithColor(currentContext, [UIColor redColor].CGColor);
            break;
    }

    CGContextBeginPath(currentContext);
    CGContextAddPath(currentContext, pathToSee.CGPath);
    CGContextDrawPath(currentContext, kCGPathStroke);

    

    CGContextRestoreGState(currentContext);

    currentContext = nil;
}

- (void) setDefaults
{
//    NSLog(@"implement setDefaults for UnitView");
}

@end
