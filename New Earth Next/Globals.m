//
//  Globals.m
//  New Earth
//
//  Created by Scott Alexander on 12/27/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "Globals.h"

// #import "ScaryBugDatabase.h"
#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

NSString* const kGtileSizeKey = @"kGtileSize";
NSString* const kGgridXOriginKey = @"kGgridXOrigin";
NSString* const kGgridYOriginKey = @"kGgridYOrigin";
NSString* const kGgridSpacingKey = @"kGgridSpacing";
NSString* const kGmapScaleKey = @"kGmapScale";
NSString* const kGgeoTileListKey = @"kGgeoTileList";
NSString* const kGbankAccountBalanceKey = @"kGbankAccountBalance";
NSString* const kGdayOfContractKey = @"kGdayOfContract";
NSString* const kGprogressSectorKey = @"kGprogressSector";
NSString* const kGdateOfLastMessageKey = @"kGdateOfLastMessage";

@implementation NewEarthGlobals
@synthesize bankAccountBalance, gridSpacing, gridXOrigin, gridYOrigin, geoTileList, numberOfHomesteadsActual, numberOfHomesteadsTarget, height, width, mapScale, tileX, tileY, tileSize, theCount, dayOfContract, lengthOfContract, isRunning;
// After @implementation
@synthesize docPath = _docPath;

#pragma mark - Singleton Methods
+(id)sharedSelf
{
    static NewEarthGlobals *sharedNeGlobals = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNeGlobals = [[self alloc] init];
    });
    return sharedNeGlobals;
    
}

#pragma mark - Initialization Methods
-(id)init
{
    self = [super init];
    if (self) {
        tileSize = 1000.0;
        mapScale = 118.29/1000;

        gridSpacing = tileSize * mapScale;
        width  = 1675;  //1530; //1430 + 100; //1600.0; // CGRectGetWidth(self.frame);// * drawScale;-75
        height = 2187; //1935; //1835 + 100; //2105.0; // CGRectGetHeight(self.frame);// * drawScale;-52
        gridXOrigin = 0; //171.0;
        gridYOrigin = 0; //182.0;
        
        tileX = gridXOrigin;
        tileY = gridYOrigin;
        theCount = 0;
        
        bankAccountBalance = 2000000.0f;
        dayOfContract = 0;
        lengthOfContract = 10; // 50;
        isRunning = NO;
        
        geoTileList = [[NSMutableDictionary alloc] initWithCapacity:20];
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}

#pragma mark - Coder methods for saving state

// Add new methods
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble: tileSize forKey: kGtileSizeKey];
    [aCoder encodeDouble: gridXOrigin forKey: kGgridXOriginKey];
    [aCoder encodeDouble: gridYOrigin forKey: kGgridYOriginKey];
    [aCoder encodeDouble: gridSpacing forKey: kGgridSpacingKey];
    [aCoder encodeDouble: mapScale forKey: kGmapScaleKey];
//    [aCoder encodeObject: geoTileList forKey: kGgeoTileListKey];
    [aCoder encodeDouble: bankAccountBalance forKey: kGbankAccountBalanceKey];
    [aCoder encodeDouble: dayOfContract forKey: kGdayOfContractKey];
    [aCoder encodeObject: _progressSector forKey: kGprogressSectorKey];
    [aCoder encodeObject: _dateOfLastMessage forKey: kGdateOfLastMessageKey];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        tileSize = [aDecoder decodeDoubleForKey:kGtileSizeKey];
        gridXOrigin = [aDecoder decodeDoubleForKey:kGgridXOriginKey];
        gridYOrigin = [aDecoder decodeDoubleForKey:kGgridYOriginKey];
        gridSpacing = [aDecoder decodeDoubleForKey:kGgridSpacingKey];
        mapScale = [aDecoder decodeDoubleForKey:kGmapScaleKey];
//        geoTileList = [aDecoder decodeObjectForKey:kGgeoTileListKey];
        bankAccountBalance = [aDecoder decodeDoubleForKey:kGbankAccountBalanceKey];
        dayOfContract = [aDecoder decodeDoubleForKey:kGdayOfContractKey];
        _progressSector = [aDecoder decodeObjectForKey:kGprogressSectorKey];
        _dateOfLastMessage = [aDecoder decodeObjectForKey:kGdateOfLastMessageKey];
    }
    return self;
}

-(void) saveContents
{
    NSLog(@"in Globals ... saveContents");
}

#pragma mark Private methods

// not going to use this unless each tile has its own file
+ (NSMutableArray *)loadTiles {
    // Get private docs dir
    NSString *documentsDirectory = [self getPrivateDocsDir];
    NSLog(@"Loading tiles from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: documentsDirectory error: &error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Create tile for each file
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity: files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare: @"maptile" options: NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent: file];
            GeoTile *theTile = [[GeoTile alloc] initWithDocPath: fullPath];
            [retval addObject: theTile];
        }
    }
    return retval;
}

// not going to use this unless each tile has its own file
+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Map Tiles"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
}

- (void)deleteDoc {
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
}

-(NSString*) resourceName: (stockType) theType
{
    NSString* retValue = @"";
    
    switch (theType) {
        case structureStock: retValue = @"Structure"; break;
        case componentStock: retValue = @"Components"; break;
        case supplyStock: retValue = @"Supplies"; break;
        case materialStock: retValue = @"Material"; break;
        case powerStock: retValue = @"Power"; break;
        case waterStock: retValue = @"Water"; break;
        case airStock: retValue = @"Air"; break;
        case foodStock: retValue = @"Food"; break;
        case laborStock: retValue = @"Labor"; break;
        case happinessStock: retValue = @"Happiness"; break;
        default: break;
    }
    return retValue;
}

@end
