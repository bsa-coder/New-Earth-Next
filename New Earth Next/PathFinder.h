//
//  PathFinder.h
//  New Earth Next
//
//  Created by Scott on 6/9/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PathFinder : NSObject

-(UIBezierPath*) simplePathFrom: (CGPoint) start to: (CGPoint) end width: (CGFloat) lineWidth;
-(UIBezierPath*) aStarPathFrom: (CGPoint) start to: (CGPoint) end width: (CGFloat) lineWidth; // implement in future

@end
