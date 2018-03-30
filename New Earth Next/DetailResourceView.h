//
//  DetailResourceView.h
//  New Earth
//
//  Created by Scott Alexander on 8/16/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewTech.h"
#import "ItemEnums.h"

@interface DetailResourceView : NSObject
@property NSString* ResourceName;
@property NSString* ResourceRateMake;
@property NSString* ResourceRateTake;
@property NSString* ResourceRateBake;
@property UIColor* BackgroundColor;

@property CGRect nameRect;
@property CGRect produceRect;
@property CGRect buildRect;
@property CGRect repairRect;

@property NewTech* theUnit;
@property stockType theResource;

-(id) initForResource:(stockType) theResource WithUnit:(NewTech*) aUnit;
//-(void)setLabelValuesForResource:(stockType) theResource forUnit:(NewTech*) theUnit;

@end
