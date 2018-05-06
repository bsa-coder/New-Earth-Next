//
//  FileOps.m
//  New Earth Next
//
//  Created by David Alexander on 3/30/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

// contains functions to read and write to the file system
// these used to be in the AppDelegate

#import "FileOps.h"

@implementation FileOps

#pragma mark - Resource folder locations

- (NSString *) getPrivateDocsDirFor:(NSString*) theTarget
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:theTarget];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    
    if (error) {
        documentsDirectory = @"";
        NSLog(@"Error was code: %ld - message: %@", (long)error.code, error.localizedDescription);
    }
    return documentsDirectory;
}

- (NSString *) getUnitsDir
{
    NSString* unitsDir = @"";
    unitsDir = [self getPrivateDocsDirFor:@"Warehouse"];
    return unitsDir;
}

- (NSString *) getMapTilesDir
{
    NSString* MapTilesDir = @"";
    MapTilesDir = [self getPrivateDocsDirFor:@"Map Tiles"];
    return MapTilesDir;
}

-(NSArray*) getContentsOfDirAt:(NSString*) thePath
{
    NSError* error;
    NSArray* returnArray;
    
    returnArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: thePath error: &error];
    if (error) { NSLog(@"contents of path error: %ld - %@ (size: %ld)", (long) error.code, error.localizedDescription, (unsigned long)returnArray.count); }
    
    return returnArray;
}

#pragma mark - Inactive Methods - Map Tiles

// not going to use this unless each tile has its own file
+ (NSString *) getPrivateDocsDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Map Tiles"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    
    if (error) {
        documentsDirectory = @"";
        NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
    }
    return documentsDirectory;
}
/*
// not going to use this unless each tile has its own file
- (void)saveTileData {
    
    NSData* tileData = [self createMapTileData];
    
    // find the folder to deposit the tile data
    NSString *documentsDirectory = [self getMapTilesDir];
    if (documentsDirectory == nil) {
        NSLog(@"Unable to find/create %@.", documentsDirectory);
        [self initBaseTiles];
        return;
    }
    
    result = [self writeTileData: tileData ToFolder: documentsDirectory];
    if (!result) {
        NSLog(@"unable to write tile data to folder");
    }
}
*/
/*
// not going to use this unless each tile has its own file
- (void)saveTileData {
    
    if (theGlobals.geoTileList == nil) return;
    if (theGlobals.geoTileList.count <= 0) return;
    
    //     [self createDataPath];
    
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
    
    // find the folder to deposit the tile data
    NSString *documentsDirectory = [self getMapTilesDir];
    if (documentsDirectory == @"") {
        NSLog(@"Unable to find/create %@.", documentsDirectory);
        [self initBaseTiles];
        return;
    }
    
    result = [self writeTileDataToFolder: documentsDirectory];
    if (!result) {
        NSLog(@"unable to write tile data to folder");
    }
}
*/

+(BOOL) writeTileData:(NSData*) theData ToFolder:(NSString*) theFolder
{
    NSString *dataPath = nil;
    BOOL result = NO;
    
    dataPath = [theFolder stringByAppendingPathComponent: @"tiles.maptile"];
    
    result = [[NSFileManager defaultManager] createFileAtPath: dataPath contents: theData attributes: nil];
    if (!result) { NSLog(@"Error was code: %d - message: %s", errno, strerror(errno)); }
    
    result = [theData writeToFile: dataPath atomically: YES];
    if (!result) { NSLog(@"Error was code: %d - message: %s", errno, strerror(errno)); }

    return result;
}

/*
// not going to use this unless each tile has its own file
- (void)saveTileData {
    
    if (theGlobals.geoTileList == nil) return;
    if (theGlobals.geoTileList.count <= 0) return;
    
    //     [self createDataPath];
    
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
    
    // find the folder to deposit the tile data
    NSString *dataPath = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Map Tiles"];
    
    NSError *error;
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    BOOL result = [fileMgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!result) { NSLog(@"Unable to find/create %@.", documentsDirectory); }
    
    // result = [fileMgr createDirectoryAtPath: dataPath withIntermediateDirectories: YES attributes: nil error: &error];
    
    if (!result) { [self initBaseTiles]; return; }
    
    dataPath = [documentsDirectory stringByAppendingPathComponent: @"tiles.maptile"];
    
    result = [fileMgr createFileAtPath: dataPath contents: data attributes: nil];
    if (!result) { NSLog(@"Error was code: %d - message: %s", errno, strerror(errno)); }
    
    result = [data writeToFile: dataPath atomically: YES];
    if (!result) { NSLog(@"Error was code: %d - message: %s", errno, strerror(errno)); }
}
*/

@end
