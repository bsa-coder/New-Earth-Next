//
//  DetailResourceView.m
//  New Earth
//
//  Created by Scott Alexander on 8/16/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "DetailResourceView.h"

@interface DetailResourceView()
{
    
}
@property stockType thisStockType;

@end

@implementation DetailResourceView

#pragma mark - Initialization Methods

-(id) initForResource:(stockType) theResource WithUnit:(NewTech*) aUnit
{
    self = [super init];
    if (self) {
        [self setLabelValuesForResource: theResource forUnit: aUnit];
    }
    return self;
}


/*
 structureStock,
 componentStock,
 supplyStock,
 materialStock,
 powerStock,
 waterStock,
 airStock,
 foodStock,
 laborStock,
 happinessStock
*/

-(void)setLabelValuesForResource:(stockType) theResource forUnit:(NewTech*) theUnit
{
    // get the resource numbers for the label
    _ResourceName = [theUnit getResourceName:theResource];
    _ResourceRateMake = [NSString stringWithFormat:@"%0.2f", [theUnit.makerBOM[theResource] floatValue]];
    _ResourceRateTake = [NSString stringWithFormat:@"%0.2f", [theUnit.takerBOM[theResource] floatValue]];
    _ResourceRateBake = [NSString stringWithFormat:@"%0.2f", [theUnit.repairBOM[theResource] floatValue]];
    _BackgroundColor = theUnit.showMyColor;
    
    _nameRect = CGRectMake(8, 10.0, 21.5, 120);
    _produceRect = CGRectMake(_nameRect.origin.x+_nameRect.size.width+25, 10.0, 21.5, 50.0);
    _buildRect = CGRectMake(_produceRect.origin.x+_produceRect.size.width+8, 10.0, 21.5, 50.0);
    _repairRect = CGRectMake(_buildRect.origin.x+_buildRect.size.width+8, 10.0, 21.5, 50.0);
    
}

@end
