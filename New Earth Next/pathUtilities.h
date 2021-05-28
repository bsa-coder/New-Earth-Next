//
//  pathUtilities.h
//  junk
//
//  Created by Scott on 7/13/19.
//  Copyright © 2019 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "segment.h"
#import "NewTech.h"

NS_ASSUME_NONNULL_BEGIN

@interface pathUtilities : NSObject

-(NSMutableArray*) makeArrayFromString: (NSString*) stringPath;
-(NSString*) makeStringFromArray: (NSMutableArray*) stringPath;
-(NSString*) bezierToString: (UIBezierPath*) p;
-(UIBezierPath*) returnUserDoneOn;
-(UIBezierPath*) returnUserDoneOff;
-(UIBezierPath*) returnUserBuild;
-(UIBezierPath*) returnUserUndone;
-(UIBezierPath*) returnWholePath;

-(void) junkMakeTestPaths;
-(NSMutableArray*) makeSimplePathFrom:(CGPoint) theSource to:(CGPoint) theDest atRate:(float) theRate;
-(NSMutableArray*) makeSimplePathFrom:(CGPoint) theSource to:(CGPoint) theDest atRate:(float) theRate ofType:(int) myType;
-(NSMutableArray*) makePathFromUnit: (NewTech*) theSource toUnit: (NewTech*) theUnit;
-(void) addSegmentToPath: (segment*) theSegment;
-(id) initMe;



@end

NS_ASSUME_NONNULL_END
