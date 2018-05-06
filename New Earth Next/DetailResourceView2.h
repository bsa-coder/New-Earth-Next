//
//  DetailResourceView2.h
//  New Earth
//
//  Created by Scott Alexander on 8/24/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewTech.h"
#import "ItemEnums.h"

@interface DetailResourceView2 : UIView
@property NSString* ResourceName;
@property NSString* ResourceRateMake;
@property NSString* ResourceRateTake;
@property NSString* ResourceRateBake;
@property UIColor* BackgroundColor;

@property CGRect nameRect;
@property CGRect produceRect;
@property CGRect buildRect;
@property CGRect repairRect;

//@property NewTech* theUnit;
//@property stockType theResource;

@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* produceLabel;
@property (nonatomic, strong) IBOutlet UILabel* buildLabel;
@property (nonatomic, strong) IBOutlet UILabel* repairLabel;

-(id) initWithUnit:(NewTech*) theUnit forResource:(stockType) theResource;

@end
