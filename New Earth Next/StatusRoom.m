//
//  StatusRoom.m
//  New Earth
//
//  Created by Scott Alexander on 6/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//
//  contains the controls for showing sustain scores and progress to winning

#import "StatusRoom.h"

@implementation StatusRoom
@synthesize myStatusView;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    UIFont* valueFont = [UIFont systemFontOfSize: 12];
//    NSString* myString = @"TileItem";
//    [myString drawAtPoint:CGPointMake(0, 0) withAttributes:@{NSFontAttributeName: valueFont}];
    
    [self.myStatusView setNeedsDisplay];

}

#pragma mark - Accessor Methods

-(void) setUnitInventory:(UnitInventory *)unitInventory
{
    _unitInventory = unitInventory;
}


@end
