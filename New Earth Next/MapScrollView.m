//
//  MapScrollView.m
//  New Earth
//
//  Created by Scott Alexander on 10/25/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "MapScrollView.h"

@implementation MapScrollView
//@synthesize aUnit, theTapLocation, theViewScale, theUnits, myMapScrollDelegate;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    self.contentMode = UIViewContentModeRedraw;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
//    self.zoomScale = 0.5;
//    self.contentOffset = CGPointMake(0,0);
//    NSLog(@"zoomscale = %0.4f offset = %@", self.zoomScale, NSStringFromCGPoint(self.contentOffset));
}


@end
