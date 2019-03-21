//
//  PathFinder.m
//  New Earth Next
//
//  Created by Scott on 6/9/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

#import "PathFinder.h"

@implementation PathFinder

-(UIBezierPath*) simplePathFrom: (CGPoint) start to: (CGPoint) end width: (CGFloat) lineWidth
{
    UIBezierPath* path = nil;
    
    path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addLineToPoint:end];
    
    path.lineWidth = lineWidth;
    
    return path;
}

-(UIBezierPath*) aStarPathFrom:(CGPoint)start to:(CGPoint)end width: (CGFloat) lineWidth
{
    NSLog(@"to be implemented in the future");
    return nil;
}

@end
