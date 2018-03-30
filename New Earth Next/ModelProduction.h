//
//  ModelProduction.h
//  junk
//
//  Created by David Alexander on 7/23/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <uikit/uikit.h>
#import "Globals.h"
#import "NewTech.h"
#import "ItemEnums.h"
#import "UnitInventory.h"
#import "GeoTile.h"
//#import "AppDelegate.h"

@interface ModelProduction : NSObject

@property NSMutableDictionary* Units;
//@property NewEarthGlobals* theGlobals;

-(CGFloat) roundToThreePlaces: (CGFloat) theFloat;
-(BOOL)calcSiteScore:(CGPoint)aLoc forUnit:(NewTech*)aUnit;
-(void) doProduction: (UnitInventory*) units;
-(CGFloat) startPositionForRow: (CGFloat) rowLoc;

// translates a tap point onto a grid tile
-(CGPoint) positionInGrid:(CGPoint) theLoc;

// translates a tap point onto a grid tile
-(CGPoint) tileVertexForPosition:(CGPoint) theLoc;

// enforce rules to prevent placing items atop others or NOGO areas
-(CGPoint) nearestAvailablePositionInGrid: (CGPoint) theLoc;


@end
