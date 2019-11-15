//
//  AvailTech.m
//  New Earth
//
//  Created by Scott Alexander on 7/5/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "AvailTech.h"

NSString* const AvailTechBeginChangesNotification = @"AvailTechBeginChangesNotification";
NSString* const AvailTechInsertEntryNotification = @"AvailTechInsertEntryNotification";
NSString* const AvailTechDeleteEntryNotification = @"AvailTechDeleteEntryNotification";
NSString* const AvailTechChangesCompleteNotification = @"AvailTechChangesCompleteNotification";

NSString* const AvailTechNotificationIndexPathKey = @"AvailTechNotificationIndexPathKey";

NSString* const kAvailTech = @"AvailTechKey";

@implementation AvailTech

#pragma mark - Singleton Methods
+(id)sharedSelf
{
    static AvailTech *sharedTech = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTech = [[self alloc] init];
    });
    return sharedTech;
    
}

#pragma mark - Initialization Methods
-(id) init
{
    self = [super init];
    if (self) {
        [self getAvailTechData];
//        [self saveTechData];
    }
    return self;
}

#pragma mark - Private Methods

-(void) fillTheStore
{
    NewTech* HOME = [[NewTech alloc] initWithType:(itemType) home withLoc:CGPointMake(-80, 0) withID:0 withSize:CGSizeMake(8, 60) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"HOME" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:100 withBuildRate:1 withRepairRate:15 withProduceRate:0 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:10 withSmoothRate:10 withConnectRate:10 withEnvelope:60.0];
    
    [HOME fillTakerBOMStruct:0.0 comp:0.0 supp:0 matl:0.0 powr:0 watr:0.0 air:0.0 food:0.1 labr:0.0];
    [HOME fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:0.0 powr:0.0 watr:0 air:0.0 food:0.0 labr:1];
    [HOME fillRepairBOMStruct:10 comp:10 supp:1 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:HOME];
    
    NewTech* PLANT = [[NewTech alloc] initWithType: (itemType) plant withLoc:CGPointMake(-52, 0) withID:0 withSize:CGSizeMake(16, 50) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor: [UIColor greenColor] withStatus:isnew withName:@"PLANT" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:100 withBuildRate:1 withRepairRate:15 withProduceRate:1 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:50.0];
    
    [PLANT fillTakerBOMStruct:0.0 comp:0.0 supp:.1 matl:0.0 powr:0.0 watr:2 air:0.0 food:0.0 labr:.1];
    [PLANT fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:.5 powr:0.0 watr:0 air:0.0 food:5 labr:0.0];
    [PLANT fillRepairBOMStruct:15 comp:10 supp:0.0 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:PLANT];
    
    NewTech* MEAT = [[NewTech alloc] initWithType:(itemType) meat withLoc:CGPointMake(-10, 0) withID:0 withSize:CGSizeMake(48, 50) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"MEAT" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:0 withBuildRate:1 withRepairRate:15 withProduceRate:1 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:100.0];
     
    [MEAT fillTakerBOMStruct:0.0 comp:0.0 supp:.1 matl:0.0 powr:1 watr:20 air:0.0 food:9.1 labr:.1];
    [MEAT fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:2.3 powr:0.0 watr:.04 air:0.0 food:5 labr:0.0];
    [MEAT fillRepairBOMStruct:10 comp:10 supp:0.0 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:MEAT];
    
    NewTech* AIR = [[NewTech alloc] initWithType:(itemType) air withLoc:CGPointMake(-20, 0) withID:0 withSize:CGSizeMake(8, 50) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"AIR" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:0 withBuildRate:1 withRepairRate:15 withProduceRate:1 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:50.0];
    
    [AIR fillTakerBOMStruct:0.0 comp:0.0 supp:.5 matl:0.0 powr:1 watr:0.0 air:0.0 food:0.0 labr:0.0];
    [AIR fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:0.0 powr:0.0 watr:0.0 air:25 food:0.0 labr:0.0];
    [AIR fillRepairBOMStruct:15 comp:10 supp:2 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:AIR];
    
    NewTech* MINE = [[NewTech alloc] initWithType:(itemType) mine withLoc:CGPointMake(-30, 0) withID:0 withSize:CGSizeMake(80, 120) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"MINE" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:0 withBuildRate:1 withRepairRate:15 withProduceRate:1 withWearoutRate:0.000125 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:216.0];
    
    [MINE fillTakerBOMStruct:0.0 comp:0.0 supp:1 matl:0.0 powr:5 watr:0.0 air:0.0 food:0.0 labr:.2];
    [MINE fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:100 powr:0.0 watr:.66 air:0.0 food:0.0 labr:0.0];
    [MINE fillRepairBOMStruct:30 comp:20 supp:4 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:.08];
    
    [self addUnit:MINE];
    
    NewTech* POWER = [[NewTech alloc] initWithType:(itemType) power withLoc:CGPointMake(-40, 0) withID:0 withSize:CGSizeMake(48, 60) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"POWER0A" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:100 withBuildRate:1 withRepairRate:5 withProduceRate:1 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:1000.0];
    
    [POWER fillTakerBOMStruct:0.0 comp:0.0 supp:0 matl:0.0 powr:0 watr:0.0 air:0.0 food:0.0 labr:0.0];
    [POWER fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:0.0 powr:50.0 watr:0 air:0.0 food:0.0 labr:0.0];
    [POWER fillRepairBOMStruct:20 comp:30 supp:5 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:POWER];
    
    NewTech* POWER00 = [[NewTech alloc] initWithType:(itemType) power withLoc:CGPointMake(-45, 0) withID:0 withSize:CGSizeMake(16, 50) withHealth:100 onDate:[NSDate date] withCost:40000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"POWER0B" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:100 withBuildRate:1 withRepairRate:5 withProduceRate:1 withWearoutRate:0.0005 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:100.0];
    
    [POWER00 fillTakerBOMStruct:0.0 comp:0.0 supp:0 matl:1.0 powr:0 watr:0.0 air:0.0 food:0.0 labr:0.0];
    [POWER00 fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:0.0 powr:10.0 watr:0 air:0.0 food:0.0 labr:0.0];
    [POWER00 fillRepairBOMStruct:5 comp:8 supp:1 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:POWER00];
    
    NewTech* WATER = [[NewTech alloc] initWithType:(itemType) water withLoc:CGPointMake(-50, 0) withID:0 withSize:CGSizeMake(8, 50) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"WATER" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:0 withBuildRate:1 withRepairRate:15 withProduceRate:1 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:50.0];
    
    [WATER fillTakerBOMStruct:0.0 comp:0.0 supp:0.5 matl:0.0 powr:4.0 watr:0.0 air:0.0 food:0.0 labr:0.0];
    [WATER fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:0.0 powr:0.0 watr:10000 air:0.0 food:0.0 labr:0.0];
    [WATER fillRepairBOMStruct:10 comp:15 supp:4 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:WATER];
    
    NewTech* WASTE = [[NewTech alloc] initWithType:(itemType) waste withLoc:CGPointMake(-50, 0) withID:0 withSize:CGSizeMake(100, 200) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"WASTE" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:0 withBuildRate:1 withRepairRate:15 withProduceRate:1 withWearoutRate:0.000125 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:1 withEnvelope:450.0];
    
    [WASTE fillTakerBOMStruct:0.0 comp:0.0 supp:.05 matl:60 powr:5 watr:0.0 air:0.0 food:0.0 labr:.1];
    [WASTE fillMakerBOMStruct:0.0 comp:0.0 supp:0 matl:50 powr:0.0 watr:0 air:0.0 food:0.0 labr:0.0];
    [WASTE fillRepairBOMStruct:20 comp:20 supp:5 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:WASTE];
    
    NewTech* CIVIL = [[NewTech alloc] initWithType:(itemType) civil withLoc:CGPointMake(-70, 0) withID:0 withSize:CGSizeMake(48, 50) withHealth:100 onDate:[NSDate date] withCost:100000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"CIVIL" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:0 withBuildRate:1 withRepairRate:15 withProduceRate:1 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:100.0];
    
    [CIVIL fillTakerBOMStruct:0.0 comp:0.0 supp:.2 matl:0.0 powr:.2 watr:1 air:5 food:0.0 labr:.2];
    [CIVIL fillMakerBOMStruct:0.0 comp:0.0 supp:0.0 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    [CIVIL fillRepairBOMStruct:10 comp:10 supp:0.0 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:CIVIL];
    
    NewTech* TREE = [[NewTech alloc] initWithType:(itemType) tree withLoc:CGPointMake(-90, 0) withID:0 withSize:CGSizeMake(100, 100) withHealth:100 onDate:[NSDate date] withCost:1000 withColor:[UIColor greenColor] withStatus:isnew withName:@"TREE" wasPlaced:NO withClean:0 withClear:0 withSmooth:100 withConnected:100 withBuildRate:1 withRepairRate:.17 withProduceRate:3.7 withWearoutRate:0 withCleanRate:5000 withClearRate:500 withSmoothRate:1 withConnectRate:1 withEnvelope:150.0];
    
    // assume 21 days to clear and 14 days to clean
    // produce rate is 15 years from 0 to maturity to get 20000 units
    
    [TREE fillTakerBOMStruct:0.0 comp:0.0 supp:0 matl:0.0 powr:0 watr:4000 air:0.0 food:0.0 labr:0.0];
    [TREE fillMakerBOMStruct:0.03 comp:0.0 supp:0.0 matl:0.01 powr:0.0 watr:0 air:0.0 food:0.0 labr:0.0];
    [TREE fillRepairBOMStruct:0.0 comp:0.0 supp:2 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:TREE];
    
    NewTech* FAB = [[NewTech alloc] initWithType:(itemType) fab withLoc:CGPointMake(-100, 0) withID:0 withSize:CGSizeMake(80, 80) withHealth:100 onDate:[NSDate date] withCost:70000.00 withColor:[UIColor greenColor] withStatus:isnew withName:@"FAB" wasPlaced:NO withClean:0 withClear:0 withSmooth:0 withConnected:0 withBuildRate:2 withRepairRate:5 withProduceRate:3 withWearoutRate:0.00025 withCleanRate:5000 withClearRate:100 withSmoothRate:100 withConnectRate:100 withEnvelope:160];
    
    [FAB fillTakerBOMStruct:0.0 comp:0.0 supp:0 matl:75 powr:4 watr:1 air:0.0 food:0.0 labr:.5];
    [FAB fillMakerBOMStruct:10 comp:30 supp:20 matl:0 powr:0.0 watr:0 air:0.0 food:0.0 labr:0.0];
    [FAB fillRepairBOMStruct:20 comp:40 supp:5 matl:0.0 powr:0.0 watr:0.0 air:0.0 food:0.0 labr:0];
    
    [self addUnit:FAB];
}

// one file per unit used to fill the store
- (void) getAvailTechData {
    
    __unused BOOL resetTile = YES;
    
    // look for folder containing avail tech files
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSArray* availTechPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* availTechPath = availTechPaths[0];
    availTechPath = [availTechPath stringByAppendingPathComponent: @"Store"];
    
    NSLog(@"\n\n\n%@\n\n\n",availTechPath);
    
    NSError* error;
    BOOL result = [fileManager createDirectoryAtPath: availTechPath withIntermediateDirectories: YES attributes: nil error: &error];
    NSLog(@"availTech path: %@", error.localizedDescription);

    if (!result) { [self fillTheStore]; [self saveTechData]; return; } // folder was missing so nothing to load from disk
    
    NSArray* availTechUnits = [fileManager contentsOfDirectoryAtPath: availTechPath error: &error];
    NSLog(@"availTechUnits path error: %@", error.localizedDescription);

    if (availTechUnits.count <= 1) { [self fillTheStore]; [self saveTechData]; return; } // folder exists but empty so nothing to load from disk
    
    for (int i = 0; i < availTechUnits.count; i++) {
        NSString* unitName = availTechUnits[i];
        // make sure filename is correct
        if ([[unitName pathExtension]  isEqual: @"tech"] ) {
        // TODO: check path for correct extension 'tech'
            NSString* pathToUnit = [availTechPath stringByAppendingPathComponent: unitName];
            NSString* fileContents = [NSString stringWithContentsOfFile: pathToUnit
                                                               encoding: NSUTF8StringEncoding
                                                                  error: &error];
            if (error) {
                NSLog(@"availTech read error: %@", error.localizedDescription);
                NSLog(@"path: %@", pathToUnit);
            }
            else {
                NewTech* newTech = [[NewTech alloc] initWithSaveString: fileContents];
                [self addUnit: newTech];
            }
        }
    }
    if ([self count] <= 0) { [self fillTheStore]; [self saveTechData];} // if no tech loaded (no tech in folder) then load defaults
}

// not going to use this as store fixed (predetermined)
- (void)saveTechData {
    
    int numberOfUnits = (int)[self count];
    if (numberOfUnits <= 0) return;
    
    for (int i = 0; i < numberOfUnits; i++) {
        NSIndexPath* nsPath = [NSIndexPath indexPathForRow:i inSection:0];
        NewTech* nt = [self unitAtIndexPath:nsPath];
        
        [nt saveTechDataToFile: @"Store"];
    }
}

#pragma mark Coding methods
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self forKey:kAvailTech];
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self = [aDecoder decodeObjectForKey:kAvailTech];
    }
    return self;
}

@end
