//
//  Globals.h
//  New Earth
//
//  Created by Scott Alexander on 12/27/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ItemEnums.h"
#import "GeoTile.h"

extern NSString* const kGtileSizeKey;
extern NSString* const kGgridXOriginKey;
extern NSString* const kGgridYOriginKey;
extern NSString* const kGgridSpacingKey;
extern NSString* const kGmapScaleKey;
extern NSString* const kGgeoTileListKey;
extern NSString* const kGbankAccountBalanceKey;
extern NSString* const kGdayOfContractKey;
extern NSString* const kGprogressSectorKey;
extern NSString* const kGdateOfLastMessageKey;

@interface NewEarthGlobals : NSObject <NSCoding>
{
    NSString *_docPath;
}


// After @interface
@property (copy) NSString *docPath;
- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
//- (void)saveData;
//- (void)deleteDoc;

@property NSInteger numberOfHomesteadsTarget;
@property NSInteger numberOfHomesteadsActual;

@property CGFloat tileSize;
@property CGFloat gridXOrigin;
@property CGFloat gridYOrigin;

@property CGFloat width; // CGRectGetWidth(self.frame);// * drawScale;-75
@property CGFloat height; // CGRectGetHeight(self.frame);// * drawScale;-52
@property CGFloat gridSpacing;

@property CGFloat tileX;
@property CGFloat tileY;
@property NSInteger theCount;

@property CGFloat mapScale;
@property BOOL isRunning;

@property (retain) NSMutableDictionary* geoTileList; // this contains GeoTiles with their data

@property CGFloat bankAccountBalance; // this is the accountBalance used to buy tech from Mars
@property int dayOfContract;
@property int lengthOfContract;
@property NSString* progressSector; // this is the calendar sector toward meeting milestone
@property NSDate* dateOfLastMessage; // use this to limit the number of messages (otherwise everyone every day)

@property CGFloat sustainScore; // from unitinventory

-(NSString*) resourceName: (stockType) theType;
-(void) saveContents;
+(id)sharedSelf;

@end
