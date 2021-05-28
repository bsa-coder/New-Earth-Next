//
//  GeoTile.h
//  New Earth
//
//  Created by Scott Alexander on 12/25/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

/*
 Rules
 1.  tile must be cleared of toxins before area can be used for farming, etc.
 2.  unit rules will determine the amount of slope, roughness, altitude to be 
 handled
 3.  tile is uniformly covered for every property, no concentrated areas
 (perhaps this will be handled by other objects for concentrations)
 */

#import <Foundation/Foundation.h>
#import <uikit/uikit.h>
#import "NewTech.h"
#import "TileItem.h"

@class NewEarthGlobals;

@interface GeoTile : NSObject <NSCoding>
{
    // 1 - clear - remove trees and rocks - trees
    // 2 - clean - remove toxins from the area
    // 3 - smooth - level the slope to place unit

    NSString* tileLocation;
    
    CGFloat altitude;   // altitude if low then may flood if high may not work for people
    CGFloat slope;      // if too steep then can't place units here
                        // angle (steepness) ... volume of material
                        // 0 -  90 deg (likely 60 deg max)
    CGFloat slopeDir;   // 0 - 360 deg
    CGFloat roughness;  // rougher requires more clearing before placing units
                        // 0 - 100
    
    // toxins maybe cleaned up by the WASTE unit(s) but could have good/better/best
    CGFloat toxin01;    // liquid
    CGFloat toxin02;    // solid
    CGFloat toxin03;    // gas - biological
    CGFloat toxin04;    // radioactive
    
    // some or much of this required for sustainability - resources for building future units
    // without requiring supplies from off-world
    CGFloat resource01; // lumber - trees that exist in nature, maybe ruins; but, likely not
    CGFloat resource02; // copper - natural or remnants from ruined buildings
    CGFloat resource03; // iron - natural or remnants from ruined buildings
    CGFloat resource04; // coal - untapped from previous deposits
    CGFloat resource05; // petroleum - untapped from previous deposits
    CGFloat resource06; // plastic - from ruined buildings and landfills
    CGFloat resource07; // glass - from ruined buildings and landfills
    
    // an array of units placed within tile
//    NewEarthGlobals* theGlobals;
 
    // nscoding
    NSString *_docPath;
    
}

@property NSString* tileLocation;

@property CGFloat altitude;
@property CGFloat slope;
@property CGFloat slopeDir;
@property CGFloat roughness;

@property CGFloat toxin01;
@property CGFloat toxin02;
@property CGFloat toxin03;
@property CGFloat toxin04;

@property CGFloat resource01;
@property CGFloat resource02;
@property CGFloat resource03;
@property CGFloat resource04;
@property CGFloat resource05;
@property CGFloat resource06;
@property CGFloat resource07;

@property (strong, nonatomic) TileItem* aTileItem;
@property (strong, nonatomic) TileItem* resource01TileItem;
@property (strong, nonatomic) TileItem* resource02TileItem;
@property (strong, nonatomic) TileItem* resource03TileItem;
@property (strong, nonatomic) TileItem* resource04TileItem;
@property (strong, nonatomic) TileItem* resource05TileItem;
@property (strong, nonatomic) TileItem* resource06TileItem;
@property (strong, nonatomic) TileItem* resource07TileItem;

@property (strong, nonatomic) TileItem* toxin01TileItem;
@property (strong, nonatomic) TileItem* toxin02TileItem;
@property (strong, nonatomic) TileItem* toxin03TileItem;
@property (strong, nonatomic) TileItem* toxin04TileItem;

@property (strong, nonatomic) TileItem* terrainRoughTileItem;
@property (strong, nonatomic) TileItem* terrainToxinTileItem;

@property (strong, nonatomic) NSMutableArray* installedUnitList;
@property (strong, nonatomic) NewEarthGlobals* theGlobals;

-(void) drawResourceViewInContext: (CGContextRef) context forView: (UIView*) theView;
-(void) drawTerrainViewInContext: (CGContextRef) context forView: (UIView*) theView;
-(void) drawBackgroundInContext: (CGContextRef) context forView: (UIView*) theView;

-(void) addEntry:(NewTech*) unitEntry;
-(NSIndexPath*) indexPathForEntry:(NewTech*) unitEntry;
-(NewTech*) entryAtIndexPath:(NSIndexPath*) indexPath;
-(void) deleteEntryAtIndexPath:(NSIndexPath*) indexPath;

-(CGFloat) valueOfResourcesAndToxins;

-(id)initWithLocation: (CGPoint) theLoc;
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
                units: (NSMutableArray*) installedUnits;

// nscoding
@property (copy) NSString *docPath;
//- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
//- (void)saveData;
//- (void)deleteDoc;

@end
