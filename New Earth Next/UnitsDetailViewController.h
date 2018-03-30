//
//  UnitsDetailViewController.h
//  New Earth
//
//  Created by Scott Alexander on 4/22/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTech.h"
#import "UnitsViewController.h"
#import "DetailResourceView.h"
#import "DetailResourceView2.h"

//@class UnitInventory;
//@class NewEarthGlobals;

@interface UnitsDetailViewController : UIViewController

//-(void) setUnitInventory:(UnitInventory *) unitInventory;
//-(void) setMyGlobals:(NewEarthGlobals *)theGlobals;

@property (retain) NewTech* aUnit;
@property CGPoint theTapLocation;

@property IBOutlet UIView* detailView;
@property IBOutlet UIStackView* resourceStack;

@property (nonatomic, strong) IBOutlet UIView* resource01;
@property IBOutlet UILabel* label01a;
@property IBOutlet UILabel* label01b;
@property IBOutlet UILabel* label01c;
@property IBOutlet UILabel* label01d;

@property (nonatomic, strong) IBOutlet UIView* resource02;
@property IBOutlet UILabel* label02a;
@property IBOutlet UILabel* label02b;
@property IBOutlet UILabel* label02c;
@property IBOutlet UILabel* label02d;

@property (nonatomic, strong) IBOutlet UIView* resource03;
@property IBOutlet UILabel* label03a;
@property IBOutlet UILabel* label03b;
@property IBOutlet UILabel* label03c;
@property IBOutlet UILabel* label03d;

@property IBOutlet UIView* resource04;
@property IBOutlet UILabel* label04a;
@property IBOutlet UILabel* label04b;
@property IBOutlet UILabel* label04c;
@property IBOutlet UILabel* label04d;

@property IBOutlet UIView* resource05;
@property IBOutlet UILabel* label05a;
@property IBOutlet UILabel* label05b;
@property IBOutlet UILabel* label05c;
@property IBOutlet UILabel* label05d;

@property IBOutlet UIView* resource06;
@property IBOutlet UILabel* label06a;
@property IBOutlet UILabel* label06b;
@property IBOutlet UILabel* label06c;
@property IBOutlet UILabel* label06d;

@property IBOutlet UIView* resource07;
@property IBOutlet UILabel* label07a;
@property IBOutlet UILabel* label07b;
@property IBOutlet UILabel* label07c;
@property IBOutlet UILabel* label07d;

@property IBOutlet UIView* resource08;
@property IBOutlet UILabel* label08a;
@property IBOutlet UILabel* label08b;
@property IBOutlet UILabel* label08c;
@property IBOutlet UILabel* label08d;

@property IBOutlet UIView* resource09;
@property IBOutlet UILabel* label09a;
@property IBOutlet UILabel* label09b;
@property IBOutlet UILabel* label09c;
@property IBOutlet UILabel* label09d;

@property IBOutlet UIView* resource10;
@property IBOutlet UILabel* label10a;
@property IBOutlet UILabel* label10b;
@property IBOutlet UILabel* label10c;
@property IBOutlet UILabel* label10d;

@property DetailResourceView* resourceInput;

@property IBOutlet UILabel* labelUnitSize;
@property IBOutlet UILabel* labelUnitEnvelope;
@property IBOutlet UILabel* labelUnitTypeClass;
@property IBOutlet UILabel* labelUnitCost;

@property IBOutlet UIImageView* imageUnitIcon;
@property IBOutlet UITextView* textUnitName;
@property IBOutlet UITextField* textUnitName2;

@property IBOutlet UILabel* labelRateProd;
@property IBOutlet UILabel* labelRateTake;
@property IBOutlet UILabel* labelRateMake;

@end
