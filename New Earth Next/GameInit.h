//
//  GameInit.h
//  New Earth Next
//
//  Created by Scott Alexander on 3/30/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileOps.h"
#import "NewTech.h"
#import "CapTech.h"
#import "Globals.h"
#import "UnitInventory.h"
#import "AvailTech.h"
#import "ModelProduction.h"
#import "NeNotifications.h"
#import "Calendar.h"
#import "PlacementEnvelope.h"

// message to update GUI
extern NSString* const kSetUpdateNotification;

// nags and updates from Corporate (Mars) like
// weather updates, progress status, demands for
// something
extern NSString* const kCorporateNotification;

// notes from on-earth sources like work complete,
// something broken, need help
extern NSString* const kSystemNotification;
extern NSString* const kMessageTypeKey;
extern NSString* const kMessageTextKey;
extern NSString* const kMessageUrgencyKey;


@interface GameInit : NSObject
@property FileOps* fo;
@property NewTech* aUnit;
@property NewEarthGlobals* theGlobals;
@property UnitInventory* theWarehouse;
@property AvailTech* theStore;
@property NECalendar* myCalendar;
@property (retain) ModelProduction* aProdEng;
@property (retain) NSNotification* updateNotification;
@property (retain) NSNotification* corporateNotification;
@property (retain) NSNotification* systemNotification;
@property (strong, nonatomic) id gameOverNotification;
@property (strong, nonatomic) NeNotifications* neNotes;

@property (nonatomic, strong) NSTimer* gameEngineTimer;

@property (nonatomic, strong) NSMutableArray* gridPaths;

-(void) startGameEngineTimer;
-(void) stopGameEngineTimer;
-(void) gameEngine: (NSTimer*) gameTimer;
//-(void) handleGameOverNotification;

-(void) initTileList;
-(void) getUnitTechDataNEW;
-(void) fillMapWithGeoData;

@end
