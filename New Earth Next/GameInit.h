//
//  GameInit.h
//  New Earth Next
//
//  Created by David Alexander on 3/30/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileOps.h"
#import "NewTech.h"
#import "Globals.h"
#import "UnitInventory.h"
#import "AvailTech.h"
#import "ModelProduction.h"

@interface GameInit : NSObject
@property FileOps* fo;
@property NewTech* aUnit;
@property NewEarthGlobals* theGlobals;
@property UnitInventory* theWarehouse;
@property AvailTech* theStore;
@property (retain) ModelProduction* aProdEng;

-(void) getUnitTechDataNEW;

@end
