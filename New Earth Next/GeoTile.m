//
//  GeoTile.m
//  New Earth
//
//  Created by Scott Alexander on 12/25/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//
//  A GeoTile contains the 'average' information that describes
//  the items within the area.  These include altitude, toxins,
//  vegetation (trees, grasses, etc.), slope, roughness, etc.

#import "GeoTile.h"
#import "Globals.h"

@implementation GeoTile
@synthesize tileLocation, altitude, slope, slopeDir, roughness;
@synthesize toxin01, toxin02, toxin03, toxin04;
@synthesize resource01, resource02, resource03, resource04, resource05, resource06, resource07;
@synthesize installedUnitList;//, theGlobals;
@synthesize resource01TileItem, resource02TileItem, resource03TileItem, resource04TileItem, resource05TileItem, resource06TileItem, resource07TileItem;
@synthesize toxin01TileItem, toxin02TileItem, toxin03TileItem, toxin04TileItem, terrainRoughTileItem, terrainToxinTileItem;

NSString* const installedUnitListBeginChangesNotification = @"installedUnitListBeginChangesNotification";
NSString* const installedUnitListInsertEntryNotification = @"installedUnitListInsertEntryNotification";
NSString* const installedUnitListDeleteEntryNotification = @"installedUnitListDeleteEntryNotification";
NSString* const installedUnitListChangesCompleteNotification = @"installedUnitListChangesCompleteNotification";

NSString* const installedUnitListNotificationIndexPathKey = @"installedUnitListNotificationIndexPathKey";

NSString* const kTileLocation = @"TileLocationKey";
NSString* const kAltitude = @"AltitudeKey";
NSString* const kSlope = @"SlopeKey";
NSString* const kSlopeDir = @"SlopeDirKey";
NSString* const kRoughness = @"TileLocationKey";
NSString* const kToxin01 = @"Toxin01Key";
NSString* const kToxin02 = @"Toxin02Key";
NSString* const kToxin03 = @"Toxin03Key";
NSString* const kToxin04 = @"Toxin04Key";
NSString* const kResource01 = @"Resource01Key";
NSString* const kResource02 = @"Resource02Key";
NSString* const kResource03 = @"Resource03Key";
NSString* const kResource04 = @"Resource04Key";
NSString* const kResource05 = @"Resource05Key";
NSString* const kResource06 = @"Resource06Key";
NSString* const kResource07 = @"Resource07Key";
NSString* const kInstalledUnitList = @"InstalledUnitListKey";


#pragma mark - Initialization Methods
-(id)init
{
    self = [super init];
    if(self)
    {
        self.theGlobals = [NewEarthGlobals sharedSelf];
        self.tileLocation = NSStringFromCGPoint(CGPointMake(0, 0));
        altitude = 0.0;
        slope = 0.0;
        slopeDir = 0.0;
        roughness = 0.0;
        toxin01 = 0.0;
        toxin02 = 0.0;
        toxin03 = 0.0;
        toxin04 = 0.0;
        resource01 = 0.0;
        resource02 = 0.0;
        resource03 = 0.0;
        resource04 = 0.0;
        resource05 = 0.0;
        resource06 = 0.0;
        resource07 = 0.0;
        
        installedUnitList = [[NSMutableArray alloc] initWithCapacity:10];
        
        CGPoint theStart = CGPointMake(0, 0);

        UIImage* anIcon = [UIImage imageNamed:@"ResourceLumberRawIcon"];
        resource01TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ResourceCopperRawIcon"];
        resource02TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ResourceIronRawIcon"];
        resource03TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ResourceRockRawIcon"];
        resource04TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        terrainRoughTileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ResourceOilRawIcon"];
        resource05TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ResourceGrainIcon"];
        resource06TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ResourceAluminumRawIcon"];
        resource07TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ToxinBiologicalIcon"];
        toxin01TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ToxinLiquidIcon"];
        toxin02TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ToxinGasIcon"];
        toxin03TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        
        anIcon = [UIImage imageNamed:@"ToxinRadioactiveIcon"];
        toxin04TileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:anIcon withStartingValue:22.0];
        terrainToxinTileItem = [[TileItem alloc] initSmallAtLocation:theStart ofType:nil withStartingValue:22.0];
 
    }
    return self;
}

-(id)initWithLocation: (CGPoint) theLoc
{
    self = [self init];
    if(self)
    {
        self.tileLocation = NSStringFromCGPoint(theLoc);
    }
    return self;
}

-(id)initWithLocation: (CGPoint) myLoc
              withAlt: (CGFloat) myAlt
            withSlope: (CGFloat) mySlope
                inDir: (CGFloat) mySlopeDir
            withRough: (CGFloat) myRough
        havingToxin01: (CGFloat) myTox01
        havingToxin02: (CGFloat) myTox02
        havingToxin03: (CGFloat) myTox03
        havingToxin04: (CGFloat) myTox04
            withRes01: (CGFloat) myRes01
            withRes02: (CGFloat) myRes02
            withRes03: (CGFloat) myRes03
            withRes04: (CGFloat) myRes04
            withRes05: (CGFloat) myRes05
            withRes06: (CGFloat) myRes06
            withRes07: (CGFloat) myRes07
                units: (NSMutableArray*) installedUnits
{
    self = [self init];
    if(self)
    {
        tileLocation = NSStringFromCGPoint(myLoc);
        altitude = myAlt;
        slope = mySlope;
        slopeDir = mySlopeDir;
        roughness = myRough;
        toxin01 = myTox01;
        toxin02 = myTox02;
        toxin03 = myTox03;
        toxin04 = myTox04;
        resource01 = myRes01;
        resource02 = myRes02;
        resource03 = myRes03;
        resource04 = myRes04;
        resource05 = myRes05;
        resource06 = myRes06;
        resource07 = myRes07;
        
        if (installedUnits != nil) {
            installedUnitList = installedUnits;
        } else {
            installedUnitList = [[NSMutableArray alloc] initWithCapacity:10];
        }
    }
    return self;
}

-(id)initWithDocPath: (NSString*) docPath
{
    self = [self init];
    if(self)
    {
        if(docPath == nil) return self;
        
        _docPath = [docPath copy];
/*
        tileLocation = NSStringFromCGPoint(myLoc);
        altitude = myAlt;
        slope = mySlope;
        slopeDir = mySlopeDir;
        roughness = myRough;
        toxin01 = myTox01;
        toxin02 = myTox02;
        toxin03 = myTox03;
        toxin04 = myTox04;
        resource01 = myRes01;
        resource02 = myRes02;
        resource03 = myRes03;
        resource04 = myRes04;
        resource05 = myRes05;
        resource06 = myRes06;
        resource07 = myRes07;
*/
        installedUnitList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

#pragma mark - Misc methods

-(CGFloat) valueOfResourcesAndToxins
{
    return toxin01 + toxin02 + toxin03 + toxin04 + resource01 + resource02 + resource03 + resource04 + resource05 + resource06 + resource07;
}

#pragma mark - Drawing methods

-(void) drawResourceViewInContext: (CGContextRef) context forView: (UIView*) theView
{
    if (CGPointFromString(tileLocation).x > 500.0 || CGPointFromString(tileLocation).y > 500.0) { return; }
    
//    theViewScale = [self.myEnvDelegate scaleForDrawingEnv:self];
    CGFloat theScale = 1.0;
    //    CGFloat mapScale = 118.29 / 1000;
    
    CGFloat theDrawScale = theScale * _theGlobals.mapScale;
    
    CGFloat tileX = CGPointFromString(tileLocation).x;
    CGFloat tileY = CGPointFromString(tileLocation).y;
    
    CGFloat colOffset = 25.0 / 2.0;
    CGFloat rowOneY = tileY + _theGlobals.tileSize * _theGlobals.mapScale - 25.0;
    CGFloat rowTwoY = rowOneY + colOffset;
    CGFloat rowThreeY = rowTwoY + colOffset;
    CGFloat colOneX = tileX + 0;
    CGFloat colTwoX = colOneX + colOffset;
    CGFloat colThreeX = colTwoX + colOffset;

    /*
    CGFloat rowY = tileY + theGlobals.tileSize * theGlobals.mapScale - 25.0;
    CGFloat col1 = tileX + theGlobals.tileSize * theGlobals.mapScale + 0.0;
    CGFloat col2 = col1 + colOffset;
    CGFloat col3 = col2 + colOffset;
    CGFloat col4 = col3 + colOffset;
    CGFloat col5 = col4 + colOffset;
    CGFloat col6 = col5 + colOffset;
    CGFloat col7 = col6 + colOffset;
     */

    CGContextRef thisContext = UIGraphicsGetCurrentContext();
    thisContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);

    // resource LUMBER
    if (resource01 > 0.0) {
        resource01TileItem.itemLocation = CGPointMake(colOneX + colOffset, rowOneY);
        resource01TileItem.itemValue = resource01;
        [resource01TileItem showMeAtLoc:resource01TileItem.itemLocation atScale:theDrawScale inContext:thisContext];
        [theView addSubview: resource01TileItem.itemOutline];
        resource01TileItem.itemOutline.center = CGPointMake(colOneX+colOffset, rowOneY);
    }
    // resource COPPER
    if (resource02 > 0.0) {
        resource02TileItem.itemLocation = CGPointMake(colTwoX + colOffset, rowOneY);
        resource02TileItem.itemValue = resource02;
        [resource02TileItem showMeAtLoc:resource02TileItem.itemLocation atScale:theDrawScale inContext:thisContext];
        [theView addSubview: resource02TileItem.itemOutline];
        resource02TileItem.itemOutline.center = CGPointMake(colTwoX+colOffset, rowOneY);
    }
    // resource IRON
    if (resource03 > 0.0) {
        resource03TileItem.itemLocation = CGPointMake(colOneX + colOffset, rowTwoY);
        resource03TileItem.itemValue = resource03;
        [resource03TileItem showMeAtLoc:resource03TileItem.itemLocation atScale:theDrawScale inContext:thisContext];
        [theView addSubview: resource03TileItem.itemOutline];
        resource03TileItem.itemOutline.center = CGPointMake(colOneX + colOffset / 2.0, rowTwoY);
    }
    // resource CARBON - OIL/COAL/ETC
    if (resource04 > 0.0) {
        resource04TileItem.itemLocation = CGPointMake(colTwoX + colOffset, rowTwoY);
        resource04TileItem.itemValue = resource04;
        [resource04TileItem showMeAtLoc:resource04TileItem.itemLocation atScale:theDrawScale inContext:thisContext];
        [theView addSubview: resource04TileItem.itemOutline];
        resource04TileItem.itemOutline.center = CGPointMake(colTwoX + colOffset / 2.0, rowTwoY);
    }
    // resource OIL/GAS
    if (resource05 > 0.0) {
        resource05TileItem.itemLocation = CGPointMake(colThreeX + colOffset, rowTwoY);
        resource05TileItem.itemValue = resource05;
        [resource05TileItem showMeAtLoc:resource05TileItem.itemLocation atScale:theDrawScale inContext:thisContext];
        [theView addSubview: resource05TileItem.itemOutline];
        resource05TileItem.itemOutline.center = CGPointMake(colThreeX + colOffset / 2.0, rowTwoY);
    }
    // resource PLASTIC
    if (resource06 > 0.0) {
        resource06TileItem.itemLocation = CGPointMake(colOneX + colOffset, rowThreeY);
        resource06TileItem.itemValue = resource06;
        [resource06TileItem showMeAtLoc:resource06TileItem.itemLocation atScale:theDrawScale inContext:thisContext];
        [theView addSubview: resource06TileItem.itemOutline];
        resource06TileItem.itemOutline.center = CGPointMake(colOneX+colOffset, rowThreeY);
    }
    // resource GLASS
    if (resource07 > 0.0) {
        resource07TileItem.itemLocation = CGPointMake(colTwoX + colOffset, rowThreeY);
        resource07TileItem.itemValue = resource07;
        [resource07TileItem showMeAtLoc:resource07TileItem.itemLocation atScale:theDrawScale inContext:thisContext];
        [theView addSubview: resource07TileItem.itemOutline];
        resource07TileItem.itemOutline.center = CGPointMake(colTwoX+colOffset, rowThreeY);
    }

    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
}

-(void) drawTerrainViewInContext: (CGContextRef) context forView: (UIView*) theView
{
    if ([self valueOfResourcesAndToxins] == 0) { return; }
    
//    if (((CGPointFromString(tileLocation).x < 205.0 && CGPointFromString(tileLocation).x > 0.0)
//        && (CGPointFromString(tileLocation).y < 200.0 && CGPointFromString(tileLocation).y > 0.0))) {
    
    CGFloat theScale = 1.0;
    CGFloat theDrawScale = theScale * _theGlobals.mapScale;

    CGFloat tileX = CGPointFromString(tileLocation).x;
    CGFloat tileY = CGPointFromString(tileLocation).y;
    
    CGFloat colOneX = tileX + _theGlobals.tileSize * _theGlobals.mapScale - 25.0;
    CGFloat colTwoX = colOneX + 25.0 / 2.0;
    CGFloat rowOneY = tileY;
    CGFloat rowTwoY = rowOneY + 25.0 / 2.0;
    CGFloat theOffset = 25.0 / 4.0;
    
    
// slope indicator (last point is slope (tileSize * tan(slope angle)))
    CGPoint startPt = CGPointMake(tileX + _theGlobals.tileSize * _theGlobals.mapScale - 25.0, tileY + 25.0);
    CGPoint nextPt = CGPointMake(startPt.x + 25.0, startPt.y);
    CGFloat theSlope = 25.0 * tan(slope *M_PI/180.0);
    CGPoint lastPt = CGPointMake(nextPt.x, tileY + 25.0 - theSlope);
    
    
//    CGRect theRectToShow = CGRectMake(colOneX, rowOneY, 50.0, 50.0);

    CGContextRef thisContext = UIGraphicsGetCurrentContext();
    thisContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
        
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPt.x + 0.5, startPt.y + 0.5 + theOffset);
    CGContextAddLineToPoint(context, nextPt.x + 0.5, nextPt.y + 0.5 + theOffset);
    CGContextAddLineToPoint(context, lastPt.x + 0.5, lastPt.y + 0.5 + theOffset);
//    CGContextAddLineToPoint(context, startPt.x + 0.5, startPt.y + 0.5);
//    [UIColor.greenColor setFill];
    CGContextClosePath(context);
    
//    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
//    CGContextDrawPath(context, kCGPathFillStroke);

//    CGContextAddRect(context, theRectToShow);

// roughness measure
    terrainRoughTileItem.itemLocation = CGPointMake(colOneX, rowOneY + theOffset);
    terrainRoughTileItem.itemValue = roughness;
    [terrainRoughTileItem showMeAtLoc:terrainRoughTileItem.itemLocation atScale:theDrawScale inContext:context];
    [theView addSubview: terrainRoughTileItem.itemOutline];
    terrainRoughTileItem.itemOutline.center = CGPointMake(colOneX + theOffset, rowOneY + theOffset + theOffset);
    terrainRoughTileItem.itemValue = roughness;
    
//    theRectToShow = CGRectMake(colOneX, rowOneY, 25.0, 25.0);
    
// toxin score (icon will show the highest amount)
    CGFloat theMax1 = (toxin01 > toxin02 ? toxin01 : toxin02);
    CGFloat theMax2 = (toxin03 > toxin04 ? toxin03 : toxin04);
    CGFloat theMax3 = (theMax1 > theMax2 ? theMax1 : theMax2);

    [terrainToxinTileItem showMeAtLoc:terrainToxinTileItem.itemLocation atScale:theDrawScale inContext:context];
    [theView addSubview: terrainToxinTileItem.itemOutline];
    terrainToxinTileItem.itemOutline.center = CGPointMake(colTwoX + theOffset, rowTwoY + theOffset + theOffset);
    terrainToxinTileItem.itemValue = toxin01 + toxin02 + toxin03 + toxin04;

    UIImage* newIcon;
    if (theMax3 == toxin01) { newIcon = toxin01TileItem.itemIcon.image; }
    else if (theMax3 == toxin02) { newIcon = toxin02TileItem.itemIcon.image; }
    else if (theMax3 == toxin03) { newIcon = toxin03TileItem.itemIcon.image; }
    else {newIcon = toxin04TileItem.itemIcon.image; }
    
    [terrainToxinTileItem changeMyIcon:newIcon];

//    [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.75] setFill];
//    [[UIColor greenColor] setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
    
    return;
//    }
}

#pragma mark - Installed Units methods

-(void) removeObjectFromInstalledUnitListAtIndex:(NSUInteger)index
{
    [self.installedUnitList removeObjectAtIndex:index];
}

-(void) addEntry:(NewTech *)unitEntry// toLoc:(CGPoint)theLoc
{
    // adding a new entry to the unit inventory
    // the new unit must have a unique location; but, unplaced as it is the index for the inventory so ...
    
    // add unit to installed list for tile
    [self.installedUnitList addObject:unitEntry];
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:installedUnitListBeginChangesNotification object:self];
    //TODO:  get point from unitInventoryList, use it to add to unitInventory
    //    [self insertObject:unitEntry inunitInventoryListAtIndex:index];
    //    [center postNotificationName:UnitInventoryInsertEntryNotification object:self];
    //    [center postNotificationName:UnitInventoryChangesCompleteNotification object:self];
}

-(NSIndexPath*) indexPathForEntry:(NewTech*) theUnit
{
    NSUInteger row = [self.installedUnitList indexOfObject:theUnit];
    return [NSIndexPath indexPathForRow:row inSection:0]; // TODO: may have sections and will need to handle
}

-(NewTech*) entryAtIndexPath:(NSIndexPath *)indexPath
{
    return self.installedUnitList[(NSUInteger)indexPath.row];
}

-(void) deleteEntryAtIndexPath:(NSIndexPath *)indexPath
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:installedUnitListBeginChangesNotification object:self];
    //TODO:  get point from unitInventoryList, find it in unitInventory, delete it there also
    [self removeObjectFromInstalledUnitListAtIndex:indexPath.row];
    [center postNotificationName:installedUnitListDeleteEntryNotification object:self];
    [center postNotificationName:installedUnitListChangesCompleteNotification object:self];
}

#pragma mark - NSCoding methods

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tileLocation forKey:kTileLocation];
    [aCoder encodeDouble:self.altitude forKey:kAltitude];
    [aCoder encodeDouble:self.slope forKey:kSlope];
    [aCoder encodeDouble:self.slopeDir forKey:kSlopeDir];
    [aCoder encodeDouble:self.roughness forKey:kRoughness];
    [aCoder encodeDouble:self.toxin01 forKey:kToxin01];
    [aCoder encodeDouble:self.toxin02 forKey:kToxin02];
    [aCoder encodeDouble:self.toxin03 forKey:kToxin03];
    [aCoder encodeDouble:self.toxin04 forKey:kToxin04];
    [aCoder encodeDouble:self.resource01 forKey:kResource01];
    [aCoder encodeDouble:self.resource02 forKey:kResource02];
    [aCoder encodeDouble:self.resource03 forKey:kResource03];
    [aCoder encodeDouble:self.resource04 forKey:kResource04];
    [aCoder encodeDouble:self.resource05 forKey:kResource05];
    [aCoder encodeDouble:self.resource06 forKey:kResource06];
    [aCoder encodeDouble:self.resource07 forKey:kResource07];
    [aCoder encodeObject:self.installedUnitList forKey: kInstalledUnitList];
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        CGPoint _tileLocation = CGPointFromString([aDecoder decodeObjectForKey:kTileLocation]);
        CGFloat _altitude = [aDecoder decodeDoubleForKey:kAltitude];
        CGFloat _slope = [aDecoder decodeDoubleForKey:kSlope];
        CGFloat _slopeDir = [aDecoder decodeDoubleForKey:kSlopeDir];
        CGFloat _roughness = [aDecoder decodeDoubleForKey:kRoughness];
        CGFloat _toxin01 = [aDecoder decodeDoubleForKey:kToxin01];
        CGFloat _toxin02 = [aDecoder decodeDoubleForKey:kToxin02];
        CGFloat _toxin03 = [aDecoder decodeDoubleForKey:kToxin03];
        CGFloat _toxin04 = [aDecoder decodeDoubleForKey:kToxin04];
        CGFloat _resource01 = [aDecoder decodeDoubleForKey:kResource01];
        CGFloat _resource02 = [aDecoder decodeDoubleForKey:kResource02];
        CGFloat _resource03 = [aDecoder decodeDoubleForKey:kResource03];
        CGFloat _resource04 = [aDecoder decodeDoubleForKey:kResource04];
        CGFloat _resource05 = [aDecoder decodeDoubleForKey:kResource05];
        CGFloat _resource06 = [aDecoder decodeDoubleForKey:kResource06];
        CGFloat _resource07 = [aDecoder decodeDoubleForKey:kResource07];
        NSMutableArray* _installedUnitList = [aDecoder decodeObjectForKey: kInstalledUnitList];
        
        return [self initWithLocation: _tileLocation withAlt: _altitude withSlope: _slope inDir: _slopeDir withRough: _roughness havingToxin01: _toxin01 havingToxin02: _toxin02 havingToxin03: _toxin03 havingToxin04: _toxin04 withRes01: _resource01 withRes02: _resource02 withRes03: _resource03 withRes04: _resource04 withRes05: _resource05 withRes06: _resource06 withRes07: _resource07 units: _installedUnitList];

    }
    return self;
}

@end
