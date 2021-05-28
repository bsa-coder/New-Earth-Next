//
//  Envelope.h
//  New Earth
//
//  Created by Scott Alexander on 12/24/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTech.h"
#import "UnitInventory.h"
#import "GeoTile.h"
#import "Globals.h"
#import "CapTech.h"

@class Envelope;

@protocol EnvelopeViewDelegate

-(float) scaleForDrawingEnv: (Envelope*) requestor;
-(UnitInventory*) unitsToDrawEnv:(Envelope*) requestor;
-(NSMutableDictionary*) tilesToDrawEnv:(Envelope*) requestor;
-(NSMutableArray*) itemsToDrawEnv:(Envelope*) requestor;
-(CGFloat) gridSpacingEnv: (Envelope*) requestor;


@end

@interface Envelope : UIView
{
    CGPoint theUnitLocation;
    CGFloat theViewScale;
}

@property (nonatomic, strong) id <EnvelopeViewDelegate> myEnvDelegate;
@property NewTech* aUnit;
@property CGPoint theUnitLocation;
@property CGFloat theViewScale;
@property UnitInventory* theUnits;
@property NSMutableDictionary* theTiles;

-(void) setDefaults;

@end
