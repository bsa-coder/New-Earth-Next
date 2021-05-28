//
//  pathUtilities.m
//  junk
//
//  Created by Scott on 7/13/19.
//  Copyright © 2019 Scott. All rights reserved.
//

#import "pathUtilities.h"
@interface pathUtilities()
@property (strong, nonatomic) NSMutableArray* unitInventoryList;
@property (strong, nonatomic) UIBezierPath* pathToUserDoneOff;
@property (strong, nonatomic) UIBezierPath* pathToUserDoneOn;
@property (strong, nonatomic) UIBezierPath* pathToUserBuild;
@property (strong, nonatomic) UIBezierPath* pathToUserUndone;
@property (strong, nonatomic) UIBezierPath* wholePath;

@end

@implementation pathUtilities

    /*
     paths kept with ??? owners or users
        users will hold keyID to supplies (power, air, water, etc.) so a quick check to see if ON
        owners will hold keyID to paths to users (to quickly mark identities of affected users)
     paths to water/power/xxx
        will be a mesh doubly linked lists of path segments used to create path
        each segment can be ON/OFF/damaged/destroyed/new (never built)/under construction
        each segment can have a capacity
     paths under construction
     paths damaged
     */

// array of points along path ... start to end
// last point of finished construction
// next point for current construction
// last point of finished path
// convert list of path points converted to uibezierpath

-(id) initMe {
    self = [super init];
    if (self) {
        _pathToUserDoneOff = [[UIBezierPath alloc] init];
        _pathToUserDoneOn = [[UIBezierPath alloc] init];
        _pathToUserBuild = [[UIBezierPath alloc] init];
        _pathToUserUndone = [[UIBezierPath alloc] init];
    }
   return self;
}


-(UIBezierPath*) makePathFromString: (NSString*) theStringPath
{
    // create bezierpath from the supplied string (comma delimited)
    UIBezierPath* thePath = [[UIBezierPath alloc] init];
    // break up stringpath into points
    NSArray* tempArray = [theStringPath componentsSeparatedByString:@","];
    int numberOfSegments = (int) [tempArray count];
    
    if (numberOfSegments > 1) {
        [thePath moveToPoint: CGPointFromString(tempArray[0])];
        for (int i=1; i<=numberOfSegments; i++) {
            [thePath addLineToPoint: CGPointFromString(tempArray[i])];
        }
    }
    
    return thePath;
}

-(NSString*) bezierToString: (UIBezierPath*) p
{
    NSString* pString;
    pString = [NSString stringWithFormat:@"%@", p];
    return pString;
}

-(NSCoder*) encodePath: (UIBezierPath*) existingPath
{
    NSCoder* aCoder = [[NSCoder alloc] init];
    [aCoder encodeObject: existingPath];
    return aCoder;
}

-(NSMutableArray*) makeArrayFromString: (NSString*) stringPath
{
    NSMutableArray* theArray;
 
    // make a test array
    NSValue* theStart    = [NSValue valueWithCGPoint: CGPointMake(100, 200)];
    NSValue* theEnd      = [NSValue valueWithCGPoint: CGPointMake(75, 350)];
    CGPoint theStartPoint = [theStart CGPointValue];
    CGPoint theEndPoint = [theEnd CGPointValue];
    int theRate         = 10;
    int amtDone;
    int amtProg;
    
    // calculate length
    float pathLength = sqrtf(pow([theEnd CGPointValue].y - [theStart CGPointValue].y, 2.0) + pow([theEnd CGPointValue].x - [theStart CGPointValue].x, 2 ));
    
    // calculate segments
    int numberOfSegments = round(pathLength / theRate + 0.5);
    
    amtDone = numberOfSegments * .2;
    amtProg = amtDone + 3;
    
    // make the array
//    theArray[numberOfSegments + 1];
    float theStep = 0;
    
    // fill the array
    theArray[0] = theStart;
    
    for (int i=1; i<=numberOfSegments; i++) {
        theStep = (float) i / (float) numberOfSegments;
        theArray[i] = [NSValue valueWithCGPoint: CGPointMake(
                                theStep * (theEndPoint.x - theStartPoint.x) + theStartPoint.x + (i>amtProg ? 0 : (i>amtDone ? 15 : 0)),
                                theStep * (theEndPoint.y - theStartPoint.y) + theStartPoint.y)];
    }
    
    theArray[numberOfSegments] = theEnd;
//    theArray = (__bridge NSMutableArray *)(thePathArray);

    return theArray;
}

-(NSString*) makeStringFromArray: (NSMutableArray*) stringPath
{
    NSString* thePathString;
    
    for (int i=0; i<[stringPath count]; i++) {
        CGPoint thePoint = [stringPath[i] CGPointValue];
        thePathString = [NSString stringWithFormat:@"%@ %@ ,",thePathString, NSStringFromCGPoint(thePoint)];
    }
    return thePathString;
}

-(UIBezierPath*) returnUserDoneOff { return _pathToUserDoneOff; }
-(UIBezierPath*) returnUserDoneOn { return _pathToUserDoneOn; }
-(UIBezierPath*) returnUserBuild { return _pathToUserBuild; }
-(UIBezierPath*) returnUserUndone { return _pathToUserUndone; }
-(UIBezierPath*) returnWholePath { return _wholePath; }

-(void) addSegmentToPath: (segment*) theSegment
{
    /*
     assign a segment to a bezierPath based upon status
     pathToUserDone = completed segment
     pathToUserBuild = segment in the process of being built
     pathToUserUndone = segment waiting to be built
     
     future - show segments that are broken ... need repair
     
     wholePath = every segment along the path regardless of status
     */
    
    CGPoint startLoc = [theSegment.srcID myLoc];
    CGPoint endLoc = theSegment.myLoc;
    
    switch (theSegment.myStatus) {
        case 0:
            break;
            
        case 1:
            [_pathToUserUndone moveToPoint:startLoc];
            [_pathToUserUndone addLineToPoint:endLoc];
            break;
            
        case 2:
            [_pathToUserBuild moveToPoint:startLoc];
            [_pathToUserBuild addLineToPoint:endLoc];
            break;
            
        case 3:
            [_pathToUserDoneOff moveToPoint:startLoc];
            [_pathToUserDoneOff addLineToPoint:endLoc];
            break;
            
        case 4:
            [_pathToUserDoneOn moveToPoint:startLoc];
            [_pathToUserDoneOn addLineToPoint:endLoc];
            break;
            
        default:
            break;
    }
    if (_wholePath.empty) {
        [_wholePath moveToPoint:[theSegment.srcID myLoc]];
        [_wholePath addLineToPoint:theSegment.myLoc];
    } else {
        [_wholePath addLineToPoint:theSegment.myLoc];
    }
}

-(NSMutableArray*) makePathFromUnit: (NewTech*) theSource toUnit: (NewTech*) theUnit
{
    NSMutableArray* thePath = [[NSMutableArray alloc] init];
    CGPoint theStart = theSource.myLoc;
    CGPoint theEnd = theUnit.myLoc;

//    thePath = [self makeSimplePathFrom:theStart to:theEnd atRate:theUnit.myConnectRate];
    thePath = [self makeSimplePathFrom:theStart to:theEnd atRate:theUnit.myConnectRate ofType:theSource.myType];

    return thePath;
}

-(NSMutableArray*) makeSimplePathFrom:(CGPoint) theSource to:(CGPoint) theDest atRate:(float) theRate ofType:(int) myType
{
    // make path from source to destination
    // calculate distance from source to destination
    float deltaX = (theDest.x - theSource.x);
    float deltaY = (theDest.y - theSource.y);
    float pathLength = sqrtf(powf((theDest.x - theSource.x), 2) + powf((theDest.y - theSource.y), 2));
    
    // calculate number of segments (1 segment per day ... max 100 days)
    //  normally would be dist/build rate = num days = num segments
    int numSegments = (int) (pathLength / theRate);
    if (numSegments > 100) { numSegments = 100; } // make sure not too big
    
    NSMutableArray* gridPath = [[NSMutableArray alloc] init];
    segment* tempSeg = [[segment alloc] init];

    // create segments ... will create straight line from start to dest
    segment* aSegment = [[segment alloc] initWithId:0 name:@"theSource" loc:theSource value:1 status:4];
//    segment* aSegment = [[segment alloc] initType:0 atLoc:newPoint status:1
//                              startingAt: theSource name:@"theSource" value:1];
    aSegment.myType = myType;
    [gridPath addObject: aSegment];
    int j = 0;

    for (j = 1; j < numSegments; j++) {
        NSString* theName = [NSString stringWithFormat:@"pathFrom%@to%@:%d", NSStringFromCGPoint(theSource), NSStringFromCGPoint(theDest), j];
        CGPoint newPoint = CGPointMake(theSource.x + deltaX*j/numSegments, theSource.y + deltaY*j/numSegments);
        aSegment = [[segment alloc] initType:0 atLoc:newPoint status:1 startingAt: gridPath[j-1]
                                        name:theName value:1];
        // add segments to array
        aSegment.myType = myType;
        tempSeg = gridPath[j-1];
        tempSeg.destID = aSegment;
        [gridPath addObject:aSegment];
        tempSeg = aSegment;
    }
    
    aSegment = [[segment alloc] initType:0 atLoc:theDest status:1
                              startingAt: gridPath[[gridPath count] - 1] name:@"last seg" value:1];
    aSegment.myType = myType;
    [gridPath addObject: aSegment];
    tempSeg = gridPath[j-1];
    tempSeg.destID = aSegment;

    return gridPath;
}

-(NSMutableArray*) makeSimplePathFrom:(CGPoint) theSource to:(CGPoint) theDest atRate:(float) theRate
{
    // make path from source to destination
    // calculate distance from source to destination
    float deltaX = (theDest.x - theSource.x);
    float deltaY = (theDest.y - theSource.y);
    float pathLength = sqrtf(powf((theDest.x - theSource.x), 2) + powf((theDest.y - theSource.y), 2));
    
    // calculate number of segments (1 segment per day ... max 100 days)
    //  normally would be dist/build rate = num days = num segments
    int numSegments = (int) (pathLength / theRate);
    if (numSegments > 100) { numSegments = 100; } // make sure not too big
    
    NSMutableArray* gridPath = [[NSMutableArray alloc] init];
    
    // create segments ... will create straight line from start to dest
    segment* aSegment = [[segment alloc] initWithId:0 name:@"theSource" loc:theSource value:1 status:4];
//    segment* aSegment = [[segment alloc] initType:0 atLoc:newPoint status:1
//                              startingAt: theSource name:@"theSource" value:1];
    [gridPath addObject: aSegment];

    for (int j = 1; j < numSegments; j++) {
        NSString* theName = [NSString stringWithFormat:@"pathFrom%@to%@:%d", NSStringFromCGPoint(theSource), NSStringFromCGPoint(theDest), j];
        CGPoint newPoint = CGPointMake(theSource.x + deltaX*j/numSegments, theSource.y + deltaY*j/numSegments);
        aSegment = [[segment alloc] initType:0 atLoc:newPoint status:1 startingAt: gridPath[j-1]
                                        name:theName value:1];
        // add segments to array
        [gridPath addObject:aSegment];
    }
    
    aSegment = [[segment alloc] initType:0 atLoc:theDest status:1
                              startingAt: gridPath[[gridPath count] - 1] name:@"last seg" value:1];
    
    [gridPath addObject: aSegment];
    
    return gridPath;
}

-(NSMutableArray*) makeSimplePathFrom2:(CGPoint) theSource to:(CGPoint) theDest atRate:(float) theRate
{
    // make path from source to destination
    // calculate distance from source to destination
    float deltaX = (theDest.x - theSource.x);
    float deltaY = (theDest.y - theSource.y);
    float pathLength = sqrtf(powf((theDest.x - theSource.x), 2) + powf((theDest.y - theSource.y), 2));
    
    // calculate number of segments (1 segment per day ... max 100 days)
    //  normally would be dist/build rate = num days = num segments
    int numSegments = (int) (pathLength / theRate);
    if (numSegments > 100) { numSegments = 100; } // make sure not too big
    
    NSMutableArray* gridPath = [[NSMutableArray alloc] init];
    
    // create segments ... will create straight line from start to dest
    segment* aSegment = [[segment alloc] initWithId:0 name:@"theSource" loc:theSource value:1 status:4];
    //    segment* aSegment = [[segment alloc] initType:0 atLoc:newPoint status:1
    //                              startingAt: theSource name:@"theSource" value:1];
    [gridPath addObject: aSegment];
    
    for (int j = 1; j < numSegments; j++) {
        __unused NSString* theName = [NSString stringWithFormat:@"pathFrom%@to%@%n", NSStringFromCGPoint(theSource) ,NSStringFromCGPoint(theDest) , j];
        CGPoint newPoint = CGPointMake(theSource.x+ deltaX*j/numSegments, theSource.y + deltaY*j/numSegments);
        aSegment = [[segment alloc] initType:0 atLoc:newPoint status:1
                                  startingAt: gridPath[j-1] name:[NSString stringWithFormat:@"stuff %d",j] value:1];
        // add segments to array
        [gridPath addObject:aSegment];
        [self addSegmentToPath:aSegment];
    }
    
    aSegment = [[segment alloc] initType:0 atLoc:theDest status:1
                              startingAt: gridPath[[gridPath count] - 1] name:@"last seg" value:1];
    
    [gridPath addObject: aSegment];
    
    return gridPath;
}


-(void) junkMakeTestPaths
{
    segment *powerSource = [[segment alloc] initWithId:0 name:@"power" loc:CGPointMake(100, 100) value:5 status:0];
    
    segment *ptoA01 = [[segment alloc] initWithId:NULL name:@"ptoA01" loc:CGPointMake(125, 150) value:0 status:0];
    segment *ptoA02 = [[segment alloc] initWithId:NULL name:@"ptoA02" loc:CGPointMake(150, 150) value:0 status:0];
    segment *ptoA03 = [[segment alloc] initWithId:NULL name:@"ptoA03" loc:CGPointMake(175, 175) value:0 status:0];
    
    segment *userA  = [[segment alloc] initWithId:NULL name:@"userA"  loc:CGPointMake(200, 200) value:0 status:0];
    
    segment *ptoB01 = [[segment alloc] initWithId:NULL name:@"ptoB01" loc:CGPointMake(150, 125) value:0 status:0];
    segment *ptoB02 = [[segment alloc] initWithId:NULL name:@"ptoB02" loc:CGPointMake(200, 150) value:0 status:0];
    segment *ptoB03 = [[segment alloc] initWithId:NULL name:@"ptoB03" loc:CGPointMake(300, 125) value:0 status:0];
    
    segment *userB  = [[segment alloc] initWithId:NULL name:@"userB"  loc:CGPointMake(400, 100) value:0 status:0];
    
    ptoA01.srcID = powerSource;
    ptoA02.srcID = ptoA01;
    ptoA03.srcID = ptoA02;
    userA.srcID = ptoA03;
    
    powerSource.destID = ptoA01;
    ptoA01.destID = ptoA02;
    ptoA02.destID = ptoA03;
    ptoA03.destID = userA;
    
    ptoA02.myStatus = 1;
    ptoA03.myStatus = 2;
    userA.myStatus = 0;
    
    ptoB01.srcID = powerSource;
    ptoB02.srcID = ptoB01;
    ptoB03.srcID = ptoB02;
    userB.srcID = ptoB03;
    
    powerSource.destID = ptoB01;
    ptoB01.destID = ptoB02;
    ptoB02.destID = ptoB03;
    ptoB03.destID = userB;
    
    ptoB01.myStatus = 2;
    ptoB02.myStatus = 2;
    ptoB03.myStatus = 2;
    userB.myStatus = 2;
    
    UIBezierPath* pathToUser = [[UIBezierPath alloc] init];
    _pathToUserDoneOn = [[UIBezierPath alloc] init];
    _pathToUserDoneOff = [[UIBezierPath alloc] init];
    _pathToUserBuild = [[UIBezierPath alloc] init];
    _pathToUserUndone = [[UIBezierPath alloc] init];
    _wholePath = [[UIBezierPath alloc] init];
    
    [pathToUser moveToPoint:powerSource.myLoc];
    [pathToUser addLineToPoint:ptoA01.myLoc];
    [pathToUser addLineToPoint:ptoA02.myLoc];
    [pathToUser addLineToPoint:ptoA03.myLoc];
    [pathToUser addLineToPoint:userA.myLoc];
    
    NSString* message = [self bezierToString:pathToUser];
    NSLog(@"%@", message);
    
    [self addSegmentToPath:ptoA01];
    [self addSegmentToPath:ptoA02];
    [self addSegmentToPath:ptoA03];
    [self addSegmentToPath:userA];
    [self addSegmentToPath:ptoB01];
    [self addSegmentToPath:ptoB02];
    [self addSegmentToPath:ptoB03];
    [self addSegmentToPath:userB];
    
    
    
    CGContextRef thisContext = UIGraphicsGetCurrentContext();

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
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(50.0, 50.0)];
        [path addLineToPoint:CGPointMake(50.0, 150.0)];
        path.lineWidth = 30;
    //    [[UIColor blueColor] setStroke];
        [[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5] setStroke];
        [path stroke];

        CGContextBeginPath(thisContext);
    //    CGContextAddPath(thisContext, path.CGPath);
        CGContextDrawPath(thisContext, kCGPathStroke);

        CGContextRestoreGState(thisContext);

}



@end
