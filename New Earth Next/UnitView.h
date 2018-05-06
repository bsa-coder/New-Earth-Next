//
//  UnitView.h
//  New Earth
//
//  Created by Scott Alexander on 11/21/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTech.h"
#import "UnitInventory.h"

@class UnitView;

@protocol UnitViewDelegate

-(float) scaleForDrawingUnit: (UnitView*) requestor;
-(CGPoint) placeForDrawing:(UnitView*) requestor;
-(NewTech*) unitToDraw:(UnitView*) requestor;
-(UnitInventory*) unitsToDraw:(UnitView*) requestor;

@end

@interface UnitView : UIView
{
    CGPoint theUnitLocation;
    CGFloat theViewScale;
}

@property (nonatomic, strong) id <UnitViewDelegate> myUnitDelegate;
@property NewTech* aUnit;
@property CGPoint theUnitLocation;
@property CGFloat theViewScale;
@property UnitInventory* theUnits;

-(void) setDefaults;

@end
