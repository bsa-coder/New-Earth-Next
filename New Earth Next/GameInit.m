//
//  GameInit.m
//  New Earth Next
//
//  Created by David Alexander on 3/30/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

#import "GameInit.h"

NSString* const kSetUpdateNotification = @"SetUpdateNotification";
NSString* const kCorporateNotification = @"MessageFromHome";
NSString* const kSystemNotification = @"MessageFromTeam";
NSString* const kMessageTypeKey = @"MsgType"; // construction, weather, yourelate, ...
NSString* const kMessageTextKey = @"MsgText"; // message to display
NSString* const kMessageUrgencyKey = @"MsgFire"; // color, icons, etc

@implementation GameInit
@synthesize fo, theWarehouse, theGlobals, theStore, aProdEng;
@synthesize neNotes, updateNotification, corporateNotification, systemNotification, gameOverNotification;
@synthesize gameEngineTimer, myCalendar;

#pragma mark - Initialization Methods
-(id)init
{
    self = [super init];
    if(self)
    {
        theGlobals = [NewEarthGlobals sharedSelf];
        theWarehouse = [UnitInventory sharedSelf];
        theStore = [AvailTech sharedSelf];
        neNotes = [NeNotifications sharedSelf]; 
        aProdEng = [[ModelProduction alloc] init];
//        myCalendar = [[NECalendar alloc] init];
        myCalendar = [NECalendar sharedSelf];

        NSMutableArray* goals = myCalendar.milestoneList;
        CGPoint firstGoal = [goals[1] CGPointValue];
        NSInteger nextGoal = firstGoal.y;
        NSInteger nextDur = firstGoal.x;
        NSInteger theCount = goals.count;
        CGPoint lastGoal = [goals[theCount-1] CGPointValue];
        NSInteger contractGoal = lastGoal.y;
        NSInteger contractDur = lastGoal.x;
        theGlobals.lengthOfContract = (int) contractDur;
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"construction", kMessageTypeKey,
                              @"theMessage", kMessageTextKey,
                              @"howImportantIsIt", kMessageUrgencyKey, nil];
        
        // this notification is called by the game engine to tell other windows do update
 
        gameOverNotification =
        [NSNotification notificationWithName:kCalendarGameOverNotification
                                      object:self
                                    userInfo: nil];
        
        updateNotification =
        [NSNotification notificationWithName:kSetUpdateNotification
                                      object:self
                                    userInfo: nil];
        
        corporateNotification =
        [NSNotification notificationWithName:kCorporateNotification
                                      object:self
                                    userInfo: dict];
        
        systemNotification =
        [NSNotification notificationWithName:kSystemNotification
                                      object:self
                                    userInfo: dict];

        [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                selector:@selector(handleGameOverNotification:)
                                name:kCalendarGameOverNotification
                                object:nil];
        

        PlacementEnvelope* pe = [[PlacementEnvelope alloc] init];
        pe = nil;
    }
    return self;
}


#pragma mark - Unit Tech Methods
-(void) getUnitTechDataNEW
{
    NSString* unitTechPath = nil;
    NSError* error;
    fo = [[FileOps alloc] init];
    
    unitTechPath = [fo getUnitsDir];
    
//    NSArray* newTechUnits = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: unitTechPath error: &error];
//    if (error) { NSLog(@"newTechUnits path error: %@ (count=%ld)", error.localizedDescription, (unsigned long)newTechUnits.count); }
    NSArray* newTechUnits = [fo getContentsOfDirAt: unitTechPath];
    
    if (newTechUnits.count<=0) {
        NSLog(@"newly created folder");
    }
    else
    {
        NSLog(@"existing folder count=%ld", (unsigned long)newTechUnits.count);
        
        for (int i = 0; i < newTechUnits.count; i++) {
            NSString* unitName = newTechUnits[i];
            // make sure filename is correct
            if ([[unitName pathExtension]  isEqual: @"tech"] ) {
                // TODO: check path for correct extension 'tech'
                NSString* pathToUnit = [unitTechPath stringByAppendingPathComponent: unitName];
                NSString* fileContents = [NSString stringWithContentsOfFile: pathToUnit
                                                                   encoding: NSUTF8StringEncoding
                                                                      error: &error];
                if (error) {
                    NSLog(@"unitTech read error: %@", error.localizedDescription);
                    NSLog(@"path: %@", pathToUnit);
                }
                else {
                    // check type ... if capacity type unit create CapTech else NewTech
                    NSArray *lineArr = [fileContents componentsSeparatedByString:@"\t"];
                    if ((itemType) [lineArr[4] intValue] == (itemType) power || (itemType) [lineArr[4] intValue] == (itemType) air || (itemType) [lineArr[4] intValue] == (itemType) water) {
                        CapTech* newTech = [[CapTech alloc] initWithSaveString: fileContents];
                        [theWarehouse addUnit: newTech];
                    }
                    else
                    {
                        NewTech* newTech = [[NewTech alloc] initWithSaveString: fileContents];
                        [theWarehouse addUnit: newTech];
                    }
                }
            }
        }
    }
    
    if ([theWarehouse count] <= 0) {
        NSLog(@"whseCount: %ld", (unsigned long)[theWarehouse count]);
        [self loadHQ];  // if no tech loaded (no tech in folder) then load defaults
    }
}

- (void) getUnitTechDataOLD {
    
    __unused BOOL resetTile = YES;
    
    // look for folder containing tech files
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSArray* unitTechPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* unitTechPath = unitTechPaths[0];
    unitTechPath = [unitTechPath stringByAppendingPathComponent: @"Warehouse"];
    
    NSError* error;
    BOOL result = [fileManager createDirectoryAtPath: unitTechPath withIntermediateDirectories: NO attributes: nil error: &error];
    if (result) {
        // result=YES then no existing warehouse folder so created one and add HQ
        // folder didn't exist (result=YES) then new game so load HEADQUARTERS
        NSLog(@"created new warehouse path ... so load HQ.");
        [self loadHQ];
    } else {
        // folder already exists try to load units (previous game)
        // result = NO then folder existed (or other error)
        // if error<>nil then couldn't create folder (might already exist)
        if (error && (error.code != 516)) { NSLog(@"unitTech path: %@ (%ld)", error.localizedDescription, (long)error.code); }
        error = nil;
        
        NSArray* newTechUnits = [fileManager contentsOfDirectoryAtPath: unitTechPath error: &error];
        if (error) { NSLog(@"newTechUnits path error: %@ (count=%ld)", error.localizedDescription, (unsigned long)newTechUnits.count); }
        
        for (int i = 0; i < newTechUnits.count; i++) {
            NSString* unitName = newTechUnits[i];
            // make sure filename is correct
            if ([[unitName pathExtension]  isEqual: @"tech"] ) {
                // TODO: check path for correct extension 'tech'
                NSString* pathToUnit = [unitTechPath stringByAppendingPathComponent: unitName];
                NSString* fileContents = [NSString stringWithContentsOfFile: pathToUnit
                                                                   encoding: NSUTF8StringEncoding
                                                                      error: &error];
                if (error) {
                    NSLog(@"unitTech read error: %@", error.localizedDescription);
                    NSLog(@"path: %@", pathToUnit);
                }
                else {
                    NewTech* newTech = [[NewTech alloc] initWithSaveString: fileContents];
                    [theWarehouse addUnit: newTech];
                }
            }
        }
        if ([theWarehouse count] <= 0) {
            NSLog(@"whseCount: %ld", (unsigned long)[theWarehouse count]);
            [self loadHQ];  // if no tech loaded (no tech in folder) then load defaults
        }
    }
}

// initial unit for start of a new game
// unit is self contained and has extra supplies to help operate at the game start

-(void) loadHQ
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NewTech* aUnit = [[NewTech alloc] initWithUnit:(NewTech*)[theStore unitAtIndexPath:indexPath]];
    
    aUnit.myName = @"HQ - HOME";
    aUnit.myType = (itemType) home;
    aUnit.myStatus = isnew;
//    aUnit.myPlaced = YES;
    [aUnit fillStockBOMStruct:100 comp:100 supp:100 matl:100 powr:0 watr:100 air:0 food:100 labr:1];
    aUnit.myLoc = CGPointMake(500 * theGlobals.mapScale, 500 * theGlobals.mapScale);
    [theWarehouse addUnit:aUnit];
    [aUnit saveTechDataToFile: @"Warehouse"];
    
    aUnit = nil;
}

#pragma mark - Map Tile Methods
-(void) initTileList
{
    CGFloat width = theGlobals.width;// 1600.0; // CGRectGetWidth(self.frame);// * drawScale;-75
    CGFloat height = theGlobals.height;// 2105.0; // CGRectGetHeight(self.frame);// * drawScale;-52
    
    __unused CGFloat gridXOrigin = theGlobals.gridXOrigin; // 171.0;
    CGFloat gridYOrigin = theGlobals.gridYOrigin; // 182.0;
    CGFloat gridSpacing = theGlobals.gridSpacing; // 100.0;
    
    //    CGFloat y = gridYOrigin;
    
    CGFloat tileX = 0;
    CGFloat tileY = 0;
    CGFloat rowStart = 0;
    NSInteger theMapColCount = 0;
    NSInteger theMapRowCount = 0;
    
    while (tileY <= height - gridSpacing) {
        // this is rows
        theMapColCount = 0;
        
        tileY = [aProdEng roundToThreePlaces:(theMapRowCount * gridSpacing + gridYOrigin)];
        rowStart = [aProdEng startPositionForRow:tileY];
        
        while (tileX <= width - gridSpacing) {
            // this is columns
            tileX = [aProdEng roundToThreePlaces:(theMapColCount * gridSpacing + rowStart)];
            
            CGPoint tileVertex = CGPointMake(tileX, tileY);
            GeoTile* nextTile = [[GeoTile alloc] initWithLocation:tileVertex];
            [theGlobals.geoTileList setObject:nextTile forKey:nextTile.tileLocation];
            //            NSLog(@"tileVertex: %@", NSStringFromCGPoint(tileVertex));
            theMapColCount++;
        }
        
        tileX = 0;
        theMapRowCount++;
    }
    
    NSLog(@"\n\nMAP: wide %ld  high %ld", (long)width, (long)height);
    NSLog(@"MAP: rows %ld  cols %ld", (long)theMapRowCount, (long)theMapColCount);
    NSLog(@"MAP: grid size %ld\n\n", (long)gridSpacing);
}

-(void) fillMapWithGeoData
{
    BOOL resetTile = YES;
    BOOL result = NO;
    NSError* error;
    NSString* mapTilePath = nil;
    
    CGFloat aToxin01delta = 0.0;
    CGFloat aToxin02delta = 0.0;
    CGFloat aToxin03delta = 0.0;
    CGFloat aToxin04delta = 0.0;
    CGFloat aResource01delta = 0.0;
    CGFloat aResource02delta = 0.0;
    CGFloat aResource03delta = 0.0;
    CGFloat aResource04delta = 0.0;
    CGFloat aResource05delta = 0.0;
    CGFloat aResource06delta = 0.0;
    CGFloat aResource07delta = 0.0;
    
    fo = [[FileOps alloc] init];
    
    // look for file containing map tile information
    mapTilePath = [fo getMapTilesDir];
    result = [[NSFileManager defaultManager] createDirectoryAtPath: mapTilePath withIntermediateDirectories: NO attributes: nil error: &error];
    
    if (!result) { [self initBaseTiles]; return; }
    
    NSString* kDataFile = @"tiles.maptile";
    NSString* dataPath = [mapTilePath stringByAppendingPathComponent: kDataFile];
    
    NSString* myString = [NSString stringWithContentsOfFile: dataPath
                                                   encoding: NSUTF8StringEncoding
                                                      error: &error];
    
    if (myString == nil) { [self initBaseTiles]; return; }
    
    // fill array with file contents ... one item per tile
    NSArray *arr = [myString componentsSeparatedByString:@"\n"];
    
    // step through array to get tile data
    for (int i=0; i < arr.count; i++) {
        NSString* lineToParse = arr[i];
        // parseLine - fill array with tile content - break line into pieces
        NSArray *lineArr = [lineToParse componentsSeparatedByString:@"\t"];
        if (lineArr.count > 1) {
//            for (int j=0; j<lineArr.count; j++) {
                // createTile
                CGPoint aLoc = CGPointFromString(lineArr[0]);
                CGFloat aAlt = [lineArr[1] floatValue];
                CGFloat aSlope = [lineArr[2] floatValue];
                CGFloat aSlopeDir = [lineArr[3] floatValue];
                CGFloat aRough = [lineArr[4] floatValue];
                CGFloat aToxin01 = [lineArr[5] floatValue];
                CGFloat aToxin02 = [lineArr[6] floatValue];
                CGFloat aToxin03 = [lineArr[7] floatValue];
                CGFloat aToxin04 = [lineArr[8] floatValue];
                CGFloat aResource01 = [lineArr[9] floatValue];
                CGFloat aResource02 = [lineArr[10] floatValue];
                CGFloat aResource03 = [lineArr[11] floatValue];
                CGFloat aResource04 = [lineArr[12] floatValue];
                CGFloat aResource05 = [lineArr[13] floatValue];
                CGFloat aResource06 = [lineArr[14] floatValue];
                CGFloat aResource07 = [lineArr[15] floatValue];
                
                if(!resetTile)
                {
                    aToxin01delta = [lineArr[16] floatValue];
                    aToxin02delta = [lineArr[17] floatValue];
                    aToxin03delta = [lineArr[18] floatValue];
                    aToxin04delta = [lineArr[19] floatValue];
                    aResource01delta = [lineArr[20] floatValue];
                    aResource02delta = [lineArr[21] floatValue];
                    aResource03delta = [lineArr[22] floatValue];
                    aResource04delta = [lineArr[23] floatValue];
                    aResource05delta = [lineArr[24] floatValue];
                    aResource06delta = [lineArr[25] floatValue];
                    aResource07delta = [lineArr[26] floatValue];
                }
                
                GeoTile* aNewTile = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: aLoc]
                                                              withAlt:aAlt withSlope:aSlope inDir:aSlopeDir withRough:aRough
                                                        havingToxin01:aToxin01+aToxin01delta havingToxin02:aToxin02+aToxin02delta havingToxin03:aToxin03+aToxin03delta havingToxin04:aToxin04+aToxin04delta
                                                            withRes01:aResource01+aResource01delta withRes02:aResource02+aResource02delta withRes03:aResource03+aResource03delta withRes04:aResource04+aResource04delta withRes05:aResource05+aResource05delta withRes06:aResource06+aResource06delta withRes07:aResource07+aResource07delta units: nil];
                
                // addTileToList
                [theGlobals.geoTileList setObject:aNewTile forKey:[aNewTile tileLocation]];
//            }
        }
    }
}

-(void) fillMapWithGeoDataOLD
{
    BOOL resetTile = YES;
    
    // look for file containing map tile information
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSArray* mapTilePaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* mapTilePath = mapTilePaths[0];
    mapTilePath = [mapTilePath stringByAppendingPathComponent: @"Map Tiles"];
    
    NSError* error;
    BOOL result = [fileManager createDirectoryAtPath: mapTilePath withIntermediateDirectories: YES attributes: nil error: &error];
    
    if (!result) { [self initBaseTiles]; return; }
    
    NSString* kDataFile = @"tiles.maptile";
    NSString* dataPath = [mapTilePath stringByAppendingPathComponent: kDataFile];
    
    // readLine (break file into lines)
    CGFloat aToxin01delta = 0.0;
    CGFloat aToxin02delta = 0.0;
    CGFloat aToxin03delta = 0.0;
    CGFloat aToxin04delta = 0.0;
    CGFloat aResource01delta = 0.0;
    CGFloat aResource02delta = 0.0;
    CGFloat aResource03delta = 0.0;
    CGFloat aResource04delta = 0.0;
    CGFloat aResource05delta = 0.0;
    CGFloat aResource06delta = 0.0;
    CGFloat aResource07delta = 0.0;
    
    NSString* myString = [NSString stringWithContentsOfFile: dataPath
                                                   encoding: NSUTF8StringEncoding
                                                      error: &error];
    
    if (myString == nil)
    { [self initBaseTiles]; return; }
    
    NSArray *arr = [myString componentsSeparatedByString:@"\n"];
    
    for (int i=0; i < arr.count; i++) {
        NSString* lineToParse = arr[i];
        // parseLine - break line into pieces
        NSArray *lineArr = [lineToParse componentsSeparatedByString:@"\t"];
        if (lineArr.count > 1) {
            for (int j=0; j<lineArr.count; j++) {
                // createTile
                CGPoint aLoc = CGPointFromString(lineArr[0]);
                CGFloat aAlt = [lineArr[1] floatValue];
                CGFloat aSlope = [lineArr[2] floatValue];
                CGFloat aSlopeDir = [lineArr[3] floatValue];
                CGFloat aRough = [lineArr[4] floatValue];
                CGFloat aToxin01 = [lineArr[5] floatValue];
                CGFloat aToxin02 = [lineArr[6] floatValue];
                CGFloat aToxin03 = [lineArr[7] floatValue];
                CGFloat aToxin04 = [lineArr[8] floatValue];
                CGFloat aResource01 = [lineArr[9] floatValue];
                CGFloat aResource02 = [lineArr[10] floatValue];
                CGFloat aResource03 = [lineArr[11] floatValue];
                CGFloat aResource04 = [lineArr[12] floatValue];
                CGFloat aResource05 = [lineArr[13] floatValue];
                CGFloat aResource06 = [lineArr[14] floatValue];
                CGFloat aResource07 = [lineArr[15] floatValue];
                
                if(!resetTile)
                {
                    aToxin01delta = [lineArr[16] floatValue];
                    aToxin02delta = [lineArr[17] floatValue];
                    aToxin03delta = [lineArr[18] floatValue];
                    aToxin04delta = [lineArr[19] floatValue];
                    aResource01delta = [lineArr[20] floatValue];
                    aResource02delta = [lineArr[21] floatValue];
                    aResource03delta = [lineArr[22] floatValue];
                    aResource04delta = [lineArr[23] floatValue];
                    aResource05delta = [lineArr[24] floatValue];
                    aResource06delta = [lineArr[25] floatValue];
                    aResource07delta = [lineArr[26] floatValue];
                }
                
                GeoTile* aNewTile = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: aLoc]
                                                              withAlt:aAlt withSlope:aSlope inDir:aSlopeDir withRough:aRough
                                                        havingToxin01:aToxin01+aToxin01delta havingToxin02:aToxin02+aToxin02delta havingToxin03:aToxin03+aToxin03delta havingToxin04:aToxin04+aToxin04delta
                                                            withRes01:aResource01+aResource01delta withRes02:aResource02+aResource02delta withRes03:aResource03+aResource03delta withRes04:aResource04+aResource04delta withRes05:aResource05+aResource05delta withRes06:aResource06+aResource06delta withRes07:aResource07+aResource07delta units: nil];
                
                // addTileToList
                [theGlobals.geoTileList setObject:aNewTile forKey:[aNewTile tileLocation]];
            }
        }
    }
}

#pragma mark - game engine routine methods

-(void) handleGameOverNotification: (NSNotification*) paramNotification 
{
    NSLog(@"must have received the GameOverNotification (GInit)");
    [self stopGameEngineTimer];
}

-(void) startGameEngineTimer
{
    self.gameEngineTimer = [NSTimer
                            scheduledTimerWithTimeInterval:5.0
                            target:self
                            selector:@selector(gameEngine:)
                            userInfo:nil repeats:YES];
}

-(void) stopGameEngineTimer
{
    if (self.gameEngineTimer != nil) {
        [self.gameEngineTimer invalidate];
    }
}

-(void) gameEngine: (NSTimer*) gameTimer
{
    NSLog(@"\n");
    NSLog(@"-GE------------------ another day has passed (%d) (%lu) -----------", theGlobals.dayOfContract, (unsigned long)theWarehouse.laborers);
    theGlobals.dayOfContract++;
    [aProdEng doProduction:theWarehouse];
    [theWarehouse updateMe];
//    NSLog(@"warehouse has: %lu units", (unsigned long)[theWarehouse count]);
    int locLab = (int) theWarehouse.laborers;
//    NSLog(@"before myCalendar performanceOnDay");
    [myCalendar performanceOnDay:theGlobals.dayOfContract withMySettlers: locLab];
//    NSLog(@"before postNotification:updateNotification");
    [[NSNotificationCenter defaultCenter] postNotification:updateNotification];
//    NSLog(@"after postNotification:updateNotification");
    // checkTheWeather
    // listenForCorporate
    // listenForProgress
    if (theGlobals.dayOfContract >= theGlobals.lengthOfContract) {
//        [self stopGameEngineTimer];
        [[NSNotificationCenter defaultCenter] postNotification:gameOverNotification];
    }
}

#pragma mark - Save Tile information

-(NSData*) createMapTileData
{
    if (theGlobals.geoTileList == nil) return nil;
    if (theGlobals.geoTileList.count <= 0) return nil;
    
    NSString* allTileData = @"";
    
    for (NSString* aTileID in theGlobals.geoTileList)
    {
        // make a string with the tile information
        GeoTile* aTile = [theGlobals.geoTileList objectForKey:aTileID];
        NSString* newString = [NSString stringWithFormat: @"%@ \t %0.6f \t %0.6f \t %0.6f \t %0.6f", aTile.tileLocation, aTile.altitude, aTile.slope, aTile.slopeDir, aTile.roughness];
        
        newString = [NSString stringWithFormat: @"%@ \t %0.6f \t %0.6f \t %0.6f \t %0.6f", newString, aTile.toxin01, aTile.toxin02, aTile.toxin03, aTile.toxin04];
        
        newString = [NSString stringWithFormat: @"%@ \t %0.6f \t %0.6f \t %0.6f \t %0.6f \t %0.6f \t %0.6f \t %0.6f", newString, aTile.resource01, aTile.resource02, aTile.resource03, aTile.resource04, aTile.resource05, aTile.resource06, aTile.resource07];
        
        // append the string to the fileString
        allTileData = [NSString stringWithFormat: @"%@ \n %@", allTileData, newString];
    }
    
    NSData* data = [allTileData dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}


#pragma mark - Generic Tile initialization

-(void) initBaseTiles
{
    // CGPointMake(175, 240)
    GeoTile* aTile01 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(1, 0)]
                                                 withAlt:30 withSlope:atan(20/1000.0)*180.0/M_PI inDir:180 withRough:20
                                           havingToxin01:0 havingToxin02:25 havingToxin03:0 havingToxin04:0
                                               withRes01:15 withRes02:35 withRes03:35 withRes04:0 withRes05:0 withRes06:35 withRes07:35 units: nil];
    
    //CGPointMake(290, 240)
    GeoTile* aTile02 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(119, 0)]
                                                 withAlt:45 withSlope:atan(10/1000.0)*180.0/M_PI inDir:180 withRough:20
                                           havingToxin01:0 havingToxin02:50 havingToxin03:0 havingToxin04:0
                                               withRes01:5 withRes02:150 withRes03:150 withRes04:0 withRes05:0 withRes06:95 withRes07:95 units: nil];
    
    //CGPointMake(412, 240)
    GeoTile* aTile03 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(237, 0)]
                                                 withAlt:30 withSlope:atan(60/1000.0)*180.0/M_PI inDir:0 withRough:20
                                           havingToxin01:0 havingToxin02:75 havingToxin03:0 havingToxin04:0
                                               withRes01:0 withRes02:200 withRes03:250 withRes04:5 withRes05:5 withRes06:88 withRes07:88 units: nil];
    
    //CGPointMake(530, 240)
    GeoTile* aTile04 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(355, 0)]
                                                 withAlt:30 withSlope:atan(60/1000.0)*180.0/M_PI inDir:-15 withRough:20
                                           havingToxin01:1000 havingToxin02:0 havingToxin03:0 havingToxin04:0
                                               withRes01:0 withRes02:5 withRes03:50 withRes04:5 withRes05:5 withRes06:10 withRes07:10 units: nil];
    
    //CGPointMake(650, 240)
    GeoTile* aTile05 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(474, 0)]
                                                 withAlt:10 withSlope:atan(10/1000.0)*180.0/M_PI inDir:165 withRough:20
                                           havingToxin01:20 havingToxin02:150 havingToxin03:0 havingToxin04:0
                                               withRes01:0 withRes02:75 withRes03:100 withRes04:0 withRes05:0 withRes06:30 withRes07:60 units: nil];
    
    //CGPointMake(770, 240)
    GeoTile* aTile06 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(592, 0)]
                                                 withAlt:10 withSlope:atan(10/1000.0)*180.0/M_PI inDir:180 withRough:20
                                           havingToxin01:80 havingToxin02:300 havingToxin03:0 havingToxin04:0
                                               withRes01:0 withRes02:75 withRes03:400 withRes04:15 withRes05:0 withRes06:60 withRes07:80 units: nil];
    
    [theGlobals.geoTileList setObject:aTile01 forKey:[aTile01 tileLocation]];
    [theGlobals.geoTileList setObject:aTile02 forKey:[aTile02 tileLocation]];
    [theGlobals.geoTileList setObject:aTile03 forKey:[aTile03 tileLocation]];
    [theGlobals.geoTileList setObject:aTile04 forKey:[aTile04 tileLocation]];
    [theGlobals.geoTileList setObject:aTile05 forKey:[aTile05 tileLocation]];
    [theGlobals.geoTileList setObject:aTile06 forKey:[aTile06 tileLocation]];
    
    
    //CGPointMake(235, 360)
    GeoTile* aTile11 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(60, 120)]
                                                 withAlt:50 withSlope:atan(25/1000)*180.0/M_PI inDir:0 withRough:25
                                           havingToxin01:0 havingToxin02:75 havingToxin03:0 havingToxin04:0
                                               withRes01:15 withRes02:25 withRes03:25 withRes04:0 withRes05:0 withRes06:25 withRes07:25 units: nil];
    
    //CGPointMake(350, 360)
    GeoTile* aTile12 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(178, 120)]
                                                 withAlt:20 withSlope:atan(20/1000)*180.0/M_PI inDir:0 withRough:25
                                           havingToxin01:0 havingToxin02:50 havingToxin03:0 havingToxin04:0
                                               withRes01:20 withRes02:25 withRes03:25 withRes04:0 withRes05:0 withRes06:25 withRes07:25 units: nil];
    
    //CGPointMake(470, 360)
    GeoTile* aTile13 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(296, 120)]
                                                 withAlt:2 withSlope:atan(10/1000)*180.0/M_PI inDir:0 withRough:0
                                           havingToxin01:1000 havingToxin02:250 havingToxin03:0 havingToxin04:0
                                               withRes01:10 withRes02:5 withRes03:5 withRes04:0 withRes05:0 withRes06:10 withRes07:10 units: nil];
    
    //CGPointMake(585, 360)
    GeoTile* aTile14 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(415, 120)]
                                                 withAlt:5 withSlope:atan(10/1000)*180.0/M_PI inDir:135 withRough:50
                                           havingToxin01:300 havingToxin02:500 havingToxin03:50 havingToxin04:0
                                               withRes01:5 withRes02:50 withRes03:100 withRes04:0 withRes05:0 withRes06:75 withRes07:75 units: nil];
    
    //CGPointMake(705, 360)
    GeoTile* aTile15 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(533, 120)]
                                                 withAlt:5 withSlope:atan(10/1000)*180.0/M_PI inDir:225 withRough:50
                                           havingToxin01:400 havingToxin02:2000 havingToxin03:100 havingToxin04:0
                                               withRes01:0 withRes02:150 withRes03:800 withRes04:30 withRes05:20 withRes06:120 withRes07:150 units: nil];
    
    [theGlobals.geoTileList setObject:aTile11 forKey:[aTile11 tileLocation]];
    [theGlobals.geoTileList setObject:aTile12 forKey:[aTile12 tileLocation]];
    [theGlobals.geoTileList setObject:aTile13 forKey:[aTile13 tileLocation]];
    [theGlobals.geoTileList setObject:aTile14 forKey:[aTile14 tileLocation]];
    [theGlobals.geoTileList setObject:aTile15 forKey:[aTile15 tileLocation]];
    
    //CGPointMake(175, 482)
    GeoTile* aTile31 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(1, 240)]
                                                 withAlt:30 withSlope:atan(20/1000.0)*180.0/M_PI inDir:-15 withRough:20
                                           havingToxin01:0 havingToxin02:25 havingToxin03:0 havingToxin04:0
                                               withRes01:30 withRes02:35 withRes03:35 withRes04:0 withRes05:0 withRes06:35 withRes07:35 units: nil];
    
    //CGPointMake(290, 482)
    GeoTile* aTile32 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(119, 240)]
                                                 withAlt:45 withSlope:atan(10/1000.0)*180.0/M_PI inDir:180 withRough:25
                                           havingToxin01:0 havingToxin02:50 havingToxin03:0 havingToxin04:0
                                               withRes01:15 withRes02:35 withRes03:35 withRes04:0 withRes05:0 withRes06:35 withRes07:35 units: nil];
    
    //CGPointMake(412, 482)
    GeoTile* aTile33 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(237, 240)]
                                                 withAlt:30 withSlope:atan(60/1000.0)*180.0/M_PI inDir:0 withRough:25
                                           havingToxin01:25 havingToxin02:50 havingToxin03:0 havingToxin04:0
                                               withRes01:40 withRes02:60 withRes03:60 withRes04:0 withRes05:0 withRes06:60 withRes07:60 units: nil];
    
    //CGPointMake(530, 482)
    GeoTile* aTile34 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(355, 240)]
                                                 withAlt:30 withSlope:atan(60/1000.0)*180.0/M_PI inDir:-15 withRough:0
                                           havingToxin01:1000 havingToxin02:150 havingToxin03:0 havingToxin04:0
                                               withRes01:0 withRes02:25 withRes03:25 withRes04:0 withRes05:0 withRes06:25 withRes07:25 units: nil];
    
    //CGPointMake(650, 482)
    GeoTile* aTile35 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(474, 240)]
                                                 withAlt:10 withSlope:atan(10/1000.0)*180.0/M_PI inDir:165 withRough:50
                                           havingToxin01:50 havingToxin02:300 havingToxin03:0 havingToxin04:0
                                               withRes01:5 withRes02:50 withRes03:100 withRes04:0 withRes05:0 withRes06:50 withRes07:50 units: nil];
    
    //CGPointMake(770, 482)
    GeoTile* aTile36 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(592, 240)]
                                                 withAlt:10 withSlope:atan(10/1000.0)*180.0/M_PI inDir:180 withRough:50
                                           havingToxin01:150 havingToxin02:500 havingToxin03:0 havingToxin04:0
                                               withRes01:5 withRes02:100 withRes03:150 withRes04:0 withRes05:0 withRes06:100 withRes07:100 units: nil];
    
    [theGlobals.geoTileList setObject:aTile31 forKey:[aTile31 tileLocation]];
    [theGlobals.geoTileList setObject:aTile32 forKey:[aTile32 tileLocation]];
    [theGlobals.geoTileList setObject:aTile33 forKey:[aTile33 tileLocation]];
    [theGlobals.geoTileList setObject:aTile34 forKey:[aTile34 tileLocation]];
    [theGlobals.geoTileList setObject:aTile35 forKey:[aTile35 tileLocation]];
    [theGlobals.geoTileList setObject:aTile36 forKey:[aTile36 tileLocation]];
    
    //CGPointMake(235, 600)
    GeoTile* aTile41 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(60, 360)]
                                                 withAlt:30 withSlope:atan(20/1000)*180.0/M_PI inDir:0 withRough:25
                                           havingToxin01:5 havingToxin02:95 havingToxin03:0 havingToxin04:0
                                               withRes01:15 withRes02:85 withRes03:85 withRes04:0 withRes05:0 withRes06:85 withRes07:85 units: nil];
    
    //CGPointMake(350, 600)
    GeoTile* aTile42 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(178, 360)]
                                                 withAlt:20 withSlope:atan(30/1000)*180.0/M_PI inDir:0 withRough:25
                                           havingToxin01:2 havingToxin02:15 havingToxin03:0 havingToxin04:0
                                               withRes01:35 withRes02:65 withRes03:65 withRes04:0 withRes05:0 withRes06:65 withRes07:65 units: nil];
    
    //CGPointMake(350, 600)
    GeoTile* aTile43 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(296, 360)]
                                                 withAlt:2 withSlope:atan(10/1000)*180.0/M_PI inDir:0 withRough:0
                                           havingToxin01:1000 havingToxin02:15 havingToxin03:0 havingToxin04:0
                                               withRes01:25 withRes02:10 withRes03:10 withRes04:0 withRes05:0 withRes06:10 withRes07:10 units: nil];
    
    //CGPointMake(585, 600)
    GeoTile* aTile44 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(415, 360)]
                                                 withAlt:20 withSlope:atan(30/1000)*180.0/M_PI inDir:135 withRough:50
                                           havingToxin01:15 havingToxin02:85 havingToxin03:0 havingToxin04:0
                                               withRes01:5 withRes02:95 withRes03:95 withRes04:0 withRes05:0 withRes06:95 withRes07:95 units: nil];
    
    //CGPointMake(705, 600)
    GeoTile* aTile45 = [[GeoTile alloc] initWithLocation:[aProdEng tileVertexForPosition: CGPointMake(533, 360)]
                                                 withAlt:45 withSlope:atan(30/1000)*180.0/M_PI inDir:165 withRough:25
                                           havingToxin01:90 havingToxin02:90 havingToxin03:0 havingToxin04:0
                                               withRes01:10 withRes02:90 withRes03:90 withRes04:0 withRes05:0 withRes06:90 withRes07:90 units: nil];
    
    [theGlobals.geoTileList setObject:aTile41 forKey:[aTile41 tileLocation]];
    [theGlobals.geoTileList setObject:aTile42 forKey:[aTile42 tileLocation]];
    [theGlobals.geoTileList setObject:aTile43 forKey:[aTile43 tileLocation]];
    [theGlobals.geoTileList setObject:aTile44 forKey:[aTile44 tileLocation]];
    [theGlobals.geoTileList setObject:aTile45 forKey:[aTile45 tileLocation]];
    
}

@end
