//
//  AppStatusItem.h
//  New Earth
//
//  Created by Scott Alexander on 1/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//
// this object holds the quantities displayed in the AppStatusBarView
// it is based on a resource type (labor, material, structure, etc. ... see stockType enum)
// the quantities are retrieved from the UnitInventory object (that holds the objects on the ground)

#import <Foundation/Foundation.h>
#import "ItemEnums.h"
#import "UnitInventory.h"
#import "AppStatusBarView.h"
//#import "AppDelegate.h"


@interface AppStatusItem : NSObject <AppStatusBarViewDelegate>
//@interface AppStatusItem : NSObject
{
    NSString* StockPileName;
    stockType myStockType;
    CGFloat myStockpileTotal;
    CGFloat myTakeRate;
    CGFloat myMakeRate;
    CGFloat myNewRate;
}

-(CGFloat) getMyTakeRate;
-(CGFloat) getMyMakeRate;
-(CGFloat) getMyNewRate;

@property stockType myStockType;
@property UnitInventory* myWarehouse;

//@property AppStatusBarView* myAppStatusBarView;
//@property GameViewController* myGameVC;

//-(id) initOfType: (stockType) theType;
-(id) initOfType: (stockType) theType WithViewControl:(UnitInventory*) myUnits; //appstatusitem

@end
