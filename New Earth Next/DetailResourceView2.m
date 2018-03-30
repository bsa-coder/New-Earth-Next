//
//  DetailResourceView2.m
//  New Earth
//
//  Created by Scott Alexander on 8/24/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "DetailResourceView2.h"

@implementation DetailResourceView2

-(id) initWithUnit:(NewTech*) aUnit forResource:(stockType) aResource
{
    self = [super init];
    if (self) {
        [self setLabelValuesForResource: aResource forUnit: aUnit];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setLabelValuesForResource:(stockType) theResource forUnit:(NewTech*) theUnit
{
    // get the resource numbers for the label
    _ResourceName = [theUnit getResourceName:theResource];
    _ResourceRateMake = [NSString stringWithFormat:@"%0.1f", [theUnit.makerBOM[theResource] floatValue]];
    _ResourceRateTake = [NSString stringWithFormat:@"%0.1f", [theUnit.takerBOM[theResource] floatValue]];
    _ResourceRateBake = [NSString stringWithFormat:@"%0.1f", [theUnit.repairBOM[theResource] floatValue]];
    _BackgroundColor = theUnit.showMyColor;
    
    _nameRect = CGRectMake(8, 10.0, 120, 21.5);
    _produceRect = CGRectMake(_nameRect.origin.x+_nameRect.size.width+25, 10.0, 70.0, 21.5);
    _buildRect = CGRectMake(_produceRect.origin.x+_produceRect.size.width+8, 10.0, 70.0, 21.5);
    _repairRect = CGRectMake(_buildRect.origin.x+_buildRect.size.width+8, 10.0, 70.0, 21.5);
    
    _nameLabel = [[UILabel alloc] initWithFrame:_nameRect];
    _produceLabel = [[UILabel alloc] initWithFrame:_produceRect];
    _buildLabel = [[UILabel alloc] initWithFrame:_buildRect];
    _repairLabel = [[UILabel alloc] initWithFrame:_repairRect];

    _nameLabel.text = _ResourceName;
    _produceLabel.text = _ResourceRateMake;
    _buildLabel.text = _ResourceRateTake;
    _repairLabel.text = _ResourceRateBake;
    
    _nameLabel.backgroundColor = [self getResourceColor:theResource];
    
    [self setBackgroundColor:_BackgroundColor];
    
    [self addSubview:_nameLabel];
    [self addSubview:_produceLabel];
    [self addSubview:_buildLabel];
    [self addSubview:_repairLabel];
}

-(UIColor*) getResourceColor: (stockType) aResource
{
    UIColor* retVal;
    
// create the status progress bar items
    switch (aResource) {
        case laborStock: retVal = [UIColor orangeColor]; break;
        case foodStock: retVal = [UIColor greenColor]; break;
        case waterStock: retVal = [UIColor blueColor]; break;
        case powerStock: retVal = [UIColor yellowColor]; break;
        case airStock: retVal = [UIColor cyanColor]; break;
        case supplyStock: retVal = [UIColor brownColor]; break;
        case materialStock: retVal = [UIColor magentaColor]; break;
        case componentStock: retVal = [UIColor grayColor]; break;
        case structureStock: retVal = [UIColor purpleColor]; break;
            
        default: break;
    }
    return retVal;
}

@end
