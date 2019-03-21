//
//  CapTech.m
//  New Earth Next
//
//  Created by Scott on 6/20/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//
//  This is a subclass of NewTech ... contains methods for units that are tied to a supply (like a power plant)
//

#import "CapTech.h"
#import "PathFinder.h"

@implementation CapTech
@synthesize pathsToUnits, connectedUnits;

-(void) drawPathsAtContext:(CGContextRef) context
{
    if (connectedUnits.count < 1) {
        return;
    }
    
    PathFinder* pf = [[PathFinder alloc] init];
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    
    int x = (int) connectedUnits.count;
    for (int i=0; i<x; i++) {
        UIBezierPath* tempPath = [pf simplePathFrom:myLoc to:[connectedUnits[i] myLoc] width:2.0];
        CGContextAddPath(context, tempPath.CGPath);
    }
    
    if (myType == (itemType) power) {
        [[UIColor yellowColor] setStroke];
    } else if (myType == (itemType) water) {
        [[UIColor blueColor] setStroke];
    } else if (myType == (itemType) air) {
        [[UIColor whiteColor] setStroke];
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
}

#pragma mark - Initialization methods

-(id) initWithType:(itemType) aType
           withLoc:(CGPoint) aLoc
            withID:(id) aID
          withSize:(CGSize) aSize
        withHealth:(float) aHealth
            onDate:(NSDate*) aCreateDate
          withCost:(float) aCost
         withColor:(UIColor*) aColorIs //not really used
        withStatus:(itemStatus) aStatus
          withName:(NSString*) aName
         wasPlaced:(BOOL) aPlaced
         withClean:(NSInteger) aClean
         withClear:(NSInteger) aClear
        withSmooth:(NSInteger) aSmooth
     withConnected:(NSInteger) aConnected
     withBuildRate:(NSInteger) aBuildRate
    withRepairRate:(NSInteger) aRepairRate
   withProduceRate:(NSInteger) aProduceRate
   withWearoutRate:(NSInteger) aWearoutRate
     withCleanRate:(NSInteger) aCleanRate
     withClearRate:(NSInteger) aClearRate
    withSmoothRate:(NSInteger) aSmoothRate
   withConnectRate:(NSInteger) aConnectRate
      withEnvelope:(float) aEnvelope
{
    self = [super initWithType:(itemType) aType
                       withLoc:(CGPoint) aLoc
                        withID:(id) aID
                      withSize:(CGSize) aSize
                    withHealth:(float) aHealth
                        onDate:(NSDate*) aCreateDate
                      withCost:(float) aCost
                     withColor:(UIColor*) aColorIs //not really used
                    withStatus:(itemStatus) aStatus
                      withName:(NSString*) aName
                     wasPlaced:(BOOL) aPlaced
                     withClean:(NSInteger) aClean
                     withClear:(NSInteger) aClear
                    withSmooth:(NSInteger) aSmooth
                 withConnected:(NSInteger) aConnected
                 withBuildRate:(NSInteger) aBuildRate
                withRepairRate:(NSInteger) aRepairRate
               withProduceRate:(NSInteger) aProduceRate
               withWearoutRate:(NSInteger) aWearoutRate
                 withCleanRate:(NSInteger) aCleanRate
                 withClearRate:(NSInteger) aClearRate
                withSmoothRate:(NSInteger) aSmoothRate
               withConnectRate:(NSInteger) aConnectRate
                  withEnvelope:(float) aEnvelope];
    if(self)
    {
        pathsToUnits = [[NSMutableArray alloc] initWithCapacity:10];
        [self fillPathsToUnitsPath0: nil path1: nil path2: nil path3: nil path4: nil path5: nil path6: nil path7: nil path8: nil path9: nil];
    }
    return self;
}

-(id) initWithUnit:(CapTech*) origUnit
{
    self = [super initWithUnit:(NewTech*) origUnit];
    if (self) {
        pathsToUnits = origUnit.pathsToUnits;
//        pathsToUnits = [[NSMutableArray alloc] initWithArray:origUnit.pathsToUnits];
//        [self fillPathsToUnitsPath0: nil path1: nil path2: nil path3: nil path4: nil path5: nil path6: nil path7: nil path8: nil path9: nil];
    }
    return self;
}

+(instancetype) unitLikeUnit:(CapTech*) copyUnit
{
    CapTech* aNewCapUnit = (CapTech*)[NewTech unitLikeUnit:(NewTech*) copyUnit];
    aNewCapUnit.pathsToUnits = [[NSMutableArray alloc] initWithArray:copyUnit.pathsToUnits];
    
    return aNewCapUnit;
}

-(instancetype) initWithSaveString: (NSString*) stringWithData
{
    NSArray* tempArray = [stringWithData componentsSeparatedByString:@"\t"];
    NSString* pathsToUnitsString = tempArray[tempArray.count-1];
    
    self = [super initWithSaveString: (NSString*) stringWithData];
    if (self) {
        NSArray* makerContents = [pathsToUnitsString componentsSeparatedByString: @"::"];
        [self fillPathsToUnitsPath0: [self stringtoBezierPath: makerContents[0]] path1:[self stringtoBezierPath: makerContents[1]] path2:[self stringtoBezierPath: makerContents[2]] path3:[self stringtoBezierPath: makerContents[3]] path4:[self stringtoBezierPath: makerContents[4]] path5:[self stringtoBezierPath: makerContents[5]] path6:[self stringtoBezierPath: makerContents[6]] path7:[self stringtoBezierPath: makerContents[7]] path8:[self stringtoBezierPath: makerContents[8]] path9:[self stringtoBezierPath: makerContents[9]]];
        
    }
    return self;
}

#pragma mark - Saving methods

// not going to use this as store fixed (predetermined)
- (void)saveTechDataToFile: (NSString*) FileNameAndPath {
    
    //     [self createDataPath];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* ds = [df stringFromDate: myCreateDate];
    
    // make a string with the tile information
    NSString* myLocString = NSStringFromCGPoint(myLoc);
    NSString* newString = [NSString stringWithFormat: @"%@ \t %d \t %@ \t %@ \t %d \t %d \t %f \t %d \t %@", myLocString, (int)myPlaced, myID, myName, (int) myType, (int)[self myClass], myHealth, (int) myStatus, ds];
    
    newString = [NSString stringWithFormat: @"%@ \t %d \t %d \t %d \t %d", newString, (int)myClean, (int)myClear, (int)mySmooth, (int)myConnected];
    
    newString = [NSString stringWithFormat: @"%@ \t %@ \t %0.6f \t %0.6f", newString, [NSString stringWithFormat:@"%0.6fx%0.6f",mySize.width, mySize.height], myEnvelope, myCost];
    
    newString = [NSString stringWithFormat: @"%@ \t %d \t %0.6f \t %d \t %d \t %d \t %d \t %d \t %d", newString, (int)myProduceRate, myWearoutRate, (int)myRepairRate, (int)myCleanRate, (int)myClearRate, (int)mySmoothRate, (int)myConnectRate, (int)myBuildRate];
    
    NSString* stockpileContents = [NSString stringWithFormat: @"%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f", [[self myStockpiles][0] floatValue], [[self myStockpiles][1] floatValue], [[self myStockpiles][2] floatValue], [[self myStockpiles][3] floatValue], [[self myStockpiles][4] floatValue], [[self myStockpiles][5] floatValue], [[self myStockpiles][6] floatValue], [[self myStockpiles][7] floatValue], [[self myStockpiles][8] floatValue], 0.0];//, [myStockpiles[9] floatValue] ];
    NSString* takerBOMContents = [NSString stringWithFormat: @"%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f", [[self takerBOM][0] floatValue], [[self takerBOM][1] floatValue], [[self takerBOM][2] floatValue], [[self takerBOM][3] floatValue], [[self takerBOM][4] floatValue], [[self takerBOM][5] floatValue], [[self takerBOM][6] floatValue], [[self takerBOM][7] floatValue], [[self takerBOM][8] floatValue], 0.0];//, [takerBOM[9] floatValue] ];
    NSString* makerBOMContents = [NSString stringWithFormat: @"%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f", [[self makerBOM][0] floatValue], [[self makerBOM][1] floatValue], [[self makerBOM][2] floatValue], [[self makerBOM][3] floatValue], [[self makerBOM][4] floatValue], [[self makerBOM][5] floatValue], [[self makerBOM][6] floatValue], [[self makerBOM][7] floatValue], [[self makerBOM][8] floatValue], 0.0];//, [makerBOM[9] floatValue] ];
    NSString* repairBOMContents = [NSString stringWithFormat: @"%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f::%0.6f", [[self repairBOM][0] floatValue], [[self repairBOM][1] floatValue], [[self repairBOM][2] floatValue], [[self repairBOM][3] floatValue], [[self repairBOM][4] floatValue], [[self repairBOM][5] floatValue], [[self repairBOM][6] floatValue], [[self repairBOM][7] floatValue], [[self repairBOM][8] floatValue], 0.0];//, [repairBOM[9] floatValue] ];
    
    newString = [NSString stringWithFormat: @"%@ \t %@ \t %@ \t %@ \t %@", newString, stockpileContents, takerBOMContents, makerBOMContents, repairBOMContents];
    
    NSString* pathsAsStrings = @"";
    for (int i = 0; i < pathsToUnits.count; i++) {
        NSString* tempPath = pathsToUnits[i];
//        NSData * data = [NSData archivedDataWithRootObject:pathsToUnits[i]];
        pathsAsStrings = [NSString stringWithFormat: @"%@::%@", pathsAsStrings, tempPath];
    }
    
    newString = [NSString stringWithFormat: @"%@ \t %@", newString, pathsAsStrings];
    
    NSData* data = [newString dataUsingEncoding:NSUTF8StringEncoding];
    
    // find the folder to deposit the tile data
    NSString *dataPath = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:FileNameAndPath];//@"Store"];
    
    NSError *error;
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    BOOL result = [fileMgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!result) { NSLog(@"Unable to find/create %@.", documentsDirectory); }
    
    //tt    numeric code for base type, like 01 = power
    NSString* tt = @"";
    switch (myType) {
        case home:  tt = @"01"; break;
        case plant: tt = @"02"; break;
        case meat:  tt = @"03"; break;
        case air:   tt = @"04"; break;
        case water: tt = @"05"; break;
        case waste: tt = @"06"; break;
        case mine:  tt = @"07"; break;
        case civil: tt = @"08"; break;
        case tree:  tt = @"09"; break;
        case power: tt = @"10"; break;
        case fab:   tt = @"11"; break;
            
        default:
            tt = @"00"; break;
    }
    
    //sssss alpha code for subtype, like HYDRO = hydroelectric power
    NSString* sssss = @"sssss";
    //g     numeric code for good 0, better 1, best 2
    NSString* g = [NSString stringWithFormat:@"%1.0f", (CGFloat)[self myClass]];
    //xxxx  numeric point location X coord
    NSString* xxxx = [NSString stringWithFormat:@"%4.0f", myLoc.x];
    //yyyy  numeric point location Y coord
    NSString* yyyy = [NSString stringWithFormat:@"%4.0f", myLoc.y];
    NSString* fileName = [NSString stringWithFormat:@"%@%@%@-%@%@.tech",tt,sssss,g,xxxx,yyyy];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString: @"0"];
    NSLog(@"\t\t\tfileName = %@", fileName);
    dataPath = [documentsDirectory stringByAppendingPathComponent: fileName];
    
    NSLog(@"\n\n\nsaving tech at: %@\n\n\n\n\n\n", dataPath);
    result = [fileMgr createFileAtPath: dataPath contents: data attributes: nil];
    if (!result) { NSLog(@"Error was code: %d - message: %s", errno, strerror(errno)); }
    
    // same function but different method used
    result = [data writeToFile: dataPath atomically: YES];
    if (!result) { NSLog(@"Error was code: %d - message: %s", errno, strerror(errno)); }
    
    [NSKeyedArchiver archiveRootObject:pathsToUnits toFile:dataPath];
}

#pragma mark - Saving methods

// draw lines to units
// container to hold 'attached' units


#pragma mark - Private methods

-(void) fillPathsToUnitsPath0: (UIBezierPath*) path0 path1: (UIBezierPath*) path1 path2: (UIBezierPath*) path2 path3: (UIBezierPath*) path3 path4: (UIBezierPath*) path4 path5: (UIBezierPath*) path5 path6: (UIBezierPath*) path6 path7: (UIBezierPath*) path7 path8: (UIBezierPath*) path8 path9: (UIBezierPath*) path9
{
    pathsToUnits[0] = path0;
    pathsToUnits[1] = path1;
    pathsToUnits[2] = path2;
    pathsToUnits[3] = path3;
    pathsToUnits[4] = path4;
    pathsToUnits[5] = path5;
    pathsToUnits[6] = path6;
    pathsToUnits[7] = path7;
    pathsToUnits[8] = path8;
}

-(UIBezierPath*) stringtoBezierPath: (NSString*) thePathAsString
{
    UIBezierPath* returnPath = NULL;
    return returnPath;
}

@end
