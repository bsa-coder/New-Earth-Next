//
//  AppStatusItem.m
//  New Earth
//
//  Created by Scott Alexander on 1/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "AppStatusItem.h"

@implementation AppStatusItem
@synthesize myStockType, myWarehouse;

//-(id) initOfType: (stockType) theType
-(id) initOfType: (stockType) theType WithViewControl:(UnitInventory*) myUnits //appstatusitem
{
    self = [super init];
    if (self) {
        myWarehouse = myUnits;
        myStockType = theType;
    }
    return self;
}

-(CGPoint) statItemBarLoc: (AppStatusBarView*) requestor
{
    return CGPointMake(0, 0);
}
-(UIColor*) statItemMyColor: (AppStatusBarView*) requestor
{
    return 0;
}

-(CGFloat) getMyTakeRate
{
    CGFloat theNumber = 0.0;
    theNumber = [myWarehouse getTakeRateForStocktype:self.myStockType];
    theNumber = (theNumber < 0 ? 0 : theNumber);
    return theNumber;
}
-(CGFloat) getMyMakeRate
{
    CGFloat theNumber = 0.0;
    theNumber = [myWarehouse getMakeRateForStocktype:self.myStockType];
    theNumber = (theNumber < 0 ? 0 : theNumber);
    return theNumber;
}
-(CGFloat) getMyNewRate
{
    CGFloat theNumber = 0.0;
    theNumber = [myWarehouse getNewRateForStocktype:self.myStockType];
    theNumber = (theNumber < 0 ? 0 : theNumber);
    return theNumber;
}

-(CGFloat) statItemConsume:(AppStatusBarView *)requestor { return [self getMyTakeRate]; }

-(CGFloat) statItemNewProd:(AppStatusBarView *)requestor { return [self getMyNewRate]; }

-(CGFloat) statItemProduce:(AppStatusBarView *)requestor { return [self getMyMakeRate]; }

@end
