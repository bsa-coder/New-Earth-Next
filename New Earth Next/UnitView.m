//
//  UnitView.m
//  New Earth
//
//  Created by Scott Alexander on 11/21/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "UnitView.h"

@class UnitInventory;

@interface UnitView()
@property (strong, nonatomic) UnitInventory* unitInventory;
@end

@implementation UnitView
@synthesize myUnitDelegate;
@synthesize aUnit, theUnits, theViewScale, theUnitLocation;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    self.contentMode = UIViewContentModeRedraw;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
// Drawing code
    [self setDefaults];
    
    theViewScale = [self.myUnitDelegate scaleForDrawingUnit:self];
    CGContextRef thisContext = UIGraphicsGetCurrentContext();
    
    if(!aUnit) { aUnit = [[NewTech alloc] init]; }

    theUnits = [myUnitDelegate unitsToDraw:self];
    
    if ([theUnits count] > 0) {
        for (NSInteger i = 0; i < [theUnits count]; i++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            aUnit = [theUnits unitAtIndexPath:indexPath];
//            if (aUnit && !aUnit.myPlaced) {
            if (aUnit) {
                theUnitLocation = aUnit.myLoc;
                [aUnit placeMe:aUnit atPoint:theUnitLocation atScale:theViewScale inContext:thisContext];
                [self addSubview: aUnit.myTileItem.itemOutline];
//                [self addSubview: aUnit.myTileItem.itemLabel];
                aUnit.myPlaced = YES;
            } else if (aUnit) {
                [aUnit placeMe:aUnit atPoint:aUnit.myLoc atScale:theViewScale inContext:thisContext];
            }
        }
    }

    aUnit = [myUnitDelegate unitToDraw:self];
    if(aUnit)
    {
        [aUnit placeMe:aUnit atPoint:aUnit.myLoc atScale:theViewScale inContext:thisContext];
    }
    
//    CGContextRef thisContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(thisContext);
    
    CGContextSetStrokeColorWithColor(thisContext, [[UIColor yellowColor] CGColor]);
    CGContextSetLineWidth(thisContext, 8.0);
    CGContextMoveToPoint(thisContext, 50.0, 50.0);
    CGContextAddLineToPoint(thisContext, 100.0, 100.0);
//    CGContextMoveToPoint(thisContext, 150.0, 150.0);
//    CGContextAddLineToPoint(thisContext, 250.0, 250.0);
    CGContextDrawPath(thisContext, kCGPathStroke);
    
    CGContextRestoreGState(thisContext);
    
    CGContextSaveGState(thisContext);
    
    CGContextSetStrokeColorWithColor(thisContext, [[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5] CGColor]);
    CGContextSetLineWidth(thisContext, 18.0);
//    CGContextMoveToPoint(thisContext, 50.0, 50.0);
//    CGContextAddLineToPoint(thisContext, 100.0, 100.0);
    CGContextMoveToPoint(thisContext, 100.0, 100.0);
    CGContextAddLineToPoint(thisContext, 100.0, 250.0);
    CGContextDrawPath(thisContext, kCGPathStroke);
    
    CGContextRestoreGState(thisContext);
    
}

- (void) setDefaults
{
//    NSLog(@"implement setDefaults for UnitView");
}

@end
