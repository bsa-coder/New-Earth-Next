//
//  NewTech.h
//  New Earth
//
//  Created by Scott Alexander on 7/5/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <uikit/uikit.h>
#import "ItemEnums.h"
#import "TileItem.h"
#import "segment.h"

@interface NewTech : NSObject <NSCoding>
{
    NSDate* myCreateDate; //date the class is created
    CGSize mySize;  //footprint of unit
    CGPoint myLoc;
    float myCost;
    UIColor* myColorIs;
    itemType myType;
    itemStatus myStatus;
    NSString* myName;
    BOOL myPlaced;
    id myID;
    
    NSInteger myClean;
    NSInteger myClear;
    NSInteger mySmooth;
    NSInteger myConnected;
    
    NSInteger myBuildRate;
    NSInteger myRepairRate;
    NSInteger myProduceRate;
    CGFloat myWearoutRate;
    
    NSInteger myCleanRate;
    NSInteger myClearRate;
    NSInteger mySmoothRate;
    NSInteger myConnectRate;
    
    float myEnvelope; // this is the diameter of the area influenced by this unit
    float myHealth;
    
    NSString *_docPath; // save game location
}

// After @interface
@property (copy) NSString *docPath;
//- (id)initWithDocPath:(NSString *)docPath;
- (instancetype) initWithSaveString: (NSString*) stringWithData;
- (void)saveTechDataToFile: (NSString*) FileNameAndPath;
//- (void)saveData;
//- (void)deleteDoc;

@property (strong,nonatomic) TileItem* myTileItem;

@property (strong, nonatomic) NSMutableArray* myStockpiles;
@property (strong, nonatomic) NSMutableArray* takerBOM; // mix of parts used in production
@property (strong, nonatomic) NSMutableArray* makerBOM; // mix of final parts used to fill stockpiles
@property (strong, nonatomic) NSMutableArray* repairBOM; // mix of parts that make up tech

@property NSDate* myCreateDate;
@property UIColor* myColorIs;
@property CGSize mySize;
@property CGPoint myLoc;
@property float myCost;
@property itemType myType;
@property itemStatus myStatus;
@property NSString* itemIcon;
@property NSString* myName;
@property BOOL myPlaced;
@property (readonly) id myID;
@property float myHealth;
@property float myEnvelope;

@property (strong, nonatomic) NSMutableArray* delays; // not sure what I was thinking for this
@property (strong, nonatomic) segment* source; // list of newtech units that supply power, water, etc.
@property (strong, nonatomic) NSMutableArray* pathsToSources; // hope will be list of uibezierpath objects (rather than vertices)
/*
 array[0] = power
 array[0] = water
 array[0] = air
 */

@property NSInteger myClean; // amount of cleaning (toxic materials) before smoothing
@property NSInteger myClear; // amount of clearing (rocks trees) before cleaning
@property NSInteger mySmooth; // leveling site before building
@property NSInteger myConnected; // wiring to power source (if
@property NSInteger myBuildRate; // preparation and erection of structure
@property NSInteger myRepairRate; // fixing rusting, wearing, damage, etc.
@property NSInteger myProduceRate; // making the output for the type
@property CGFloat myWearoutRate; // rusting, wearing, etc.
@property NSInteger myCleanRate;
@property NSInteger myClearRate;
@property NSInteger mySmoothRate;
@property NSInteger myConnectRate;
@property NSInteger myClass; // 0 = good, 1 = better, 2 = best

-(void) setStockpileType:(stockType) theType toValue:(CGFloat) theValue;

@property float mapScale; // TODO: need to figure out how to make global constant

-(void) placeMe:(id)myID atPoint:(CGPoint) theLoc atScale:(CGFloat) theScale inContext:(CGContextRef)context;
-(void) showMyEnvelope:(id)myID atPoint:(CGPoint) theLoc atScale:(CGFloat) theScale inContext:(CGContextRef)context;
-(UIColor*) showMyColor; //(itemType)myType

-(NSString*) printMyStores;
-(NSString*) printMe;

-(void) fillMakerBOMStruct: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor;

-(void) fillTakerBOMStruct: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor;

-(void) fillRepairBOMStruct: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor;

-(void) fillStockBOMStruct: (CGFloat) aStructure comp: (CGFloat) aComponent supp: (CGFloat) aSupply matl: (CGFloat) aMaterial powr: (CGFloat) aPower watr: (CGFloat) aWater air: (CGFloat) aAir food: (CGFloat) aFood labr: (CGFloat) aLabor;


-(id) initWithType:(itemType) aType
           withLoc:(CGPoint) aLoc
            withID:(id) aID
          withSize:(CGSize) aSize
        withHealth:(float) aHealth
            onDate:(NSDate*) aCreateDate
          withCost:(float) aCost
         withColor:(UIColor*) aColorIs
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
;

-(id) initWithUnit:(NewTech*) origUnit;

-(noteSource) getMyMessageSource;

// convenience method

+(instancetype) unitLikeUnit:(NewTech*) copyUnit;
-(NSString*) getResourceName:(stockType) theResource;
-(NSString*) getMyIcon;


@end
