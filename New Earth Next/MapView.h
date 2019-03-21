//
//  MapView.h
//  New Earth
//
//  Created by David Alexander on 7/11/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTech.h"
#import "UnitInventory.h"

@class MapView;

@protocol MapViewDelegate

-(float) scaleForDrawingOnMap: (MapView*) requestor;
-(CGPoint) placeForDrawingOnMap:(MapView*) requestor;
-(NewTech*) unitToDrawOnMap:(MapView*) requestor;
-(UnitInventory*) unitsToDrawOnMap:(MapView*) requestor;

@end

@interface MapView : UIImageView
{
    CGPoint theUnitLocation;
//    CGFloat theViewScale;
}

@property (assign, nonatomic) CGFloat gridSpacing;
@property (assign, nonatomic) CGFloat gridLineWidth;
@property (assign, nonatomic) CGFloat gridXOffset;
@property (assign, nonatomic) CGFloat gridYOffset;
@property (strong, nonatomic) UIColor* gridLineColor;

@property (nonatomic, strong) id <MapViewDelegate> myMapDelegate;

@property NewTech* aUnit;
@property CGPoint theMapLocation;
@property CGFloat theViewScale;
@property UnitInventory* theUnits;

//-(void) setDefaults;


@end
